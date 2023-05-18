<template>
  <div>
    <div v-if="error">{{ error }}</div>
    <h3 class="title">Crie sua sala</h3>
    <form action="" @submit.prevent="addRoom" class="form">
      <div class="form-group">
        <input class="input" autofocus autocomplete="off" placeholder="Crie um nome para sua sala" v-model="newRoom.name" />
        <input class="input" autofocus autocomplete="off" placeholder="Adicione uma descrição" v-model="newRoom.description" />
      </div>
      <button type="submit" class="submit-button">Criar sala</button>
    </form>

    <ul style="margin-top: 50px;">
      <li v-for="room in rooms" :key="room.id" :room="room">
        <div style="margin-bottom: 30px;">
          <p>{{ room.name }}</p>
          <div v-if="room == editedRoom">
            <form action="" @submit.prevent="updateRoom(room)" class="form">
              <div>
                <input class="input" v-model="room.name" />
                <input class="input" v-model="room.description" />
                <button type="submit" class="add-edit-button">Atualizar</button>
              </div>
            </form>
          </div>
          <button class="submit-button" @click.prevent="editRoom(room)">Editar</button>
          <button class="submit-button" @click.prevent="removeRoom(room)">Excluir</button>
          <button class="submit-button" @click.prevent="generateAccessLink(room)">Gerar Link de Acesso</button>
          <router-link class="access-button" :to="`/rooms/${room.id}/access/${room.access_code}`">Acessar sala</router-link>
        </div>
        <div v-for="video in room.videos" :key="video.id">
          <youtube :video-id="getVideoId(video.url)"></youtube>
        </div>
        <form @submit.prevent="handleVideo(room)" class="form">
          <div>
            <input type="hidden" v-model="newVideo.id" />
            <input class="input" v-model="newVideo.name" placeholder="Nome do vídeo" />
            <input class="input" v-model="newVideo.url" placeholder="URL do vídeo" />
            <input class="input" v-model="newVideo.description" placeholder="Descrição do vídeo" />
            <button type="submit" class="add-edit-button">Salvar</button>
          </div>
        </form>
      </li>
    </ul>
  </div>
</template>

<script>

import RoomAccess from '@/components/rooms/RoomAccess.vue'
import Vue from 'vue'
import VueYouTubeEmbed from 'vue-youtube-embed'
Vue.use(VueYouTubeEmbed)

export default {
  name: 'Rooms',
  props: ['videos'],
  components: {
    RoomAccess
  },
  data () {
    return {
      rooms: [],
      newRoom: {},
      error: '',
      editedRoom: '',
      newVideo: {},
      accessLink: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$httpSecured.get('/api/v1/rooms')
        .then(response => {
          this.rooms = response.data.map(room => {
            return {
              ...room,
              newVideo: { name: '', url: '', description: '' }
            }
          })
          this.loadVideos()
        })
        .catch(error => this.setError(error, 'Algo deu errado'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addRoom () {
      const value = this.newRoom
      if (!value) {
        return
      }
      this.$httpSecured.post('/api/v1/rooms/', { room: { name: value.name || '', description: value.description || '' } })
        .then(response => {
          this.rooms.push({
            ...response.data,
            newVideo: { name: '', url: '', description: '' }
          })
          this.newRoom = {}
        })
        .catch(error => this.setError(error, 'Não foi possível criar a sala'))
    },
    removeRoom (room) {
      this.$httpSecured.delete(`/api/v1/rooms/${room.id}`)
        .then(response => {
          this.rooms.splice(this.rooms.indexOf(room), 1)
          window.location.reload()
        })
        .catch(error => this.setError(error, 'Não é possível deletar a sala'))
    },
    editRoom (room) {
      const video = room.videos[0]
      if (video) {
        this.newVideo.id = video.id
      }
      this.editedRoom = room
    },
    updateRoom (room) {
      this.editedRoom = ''
      this.$httpSecured.patch(`/api/v1/rooms/${room.id}`, { room: { name: room.name, description: room.description } })
        .then(() => {
          this.loadVideos()
        })
        .catch(error => this.setError(error, 'Não foi possível atualizar a informação da sala'))
    },
    loadVideos () {
      this.rooms.forEach(room => {
        this.$httpSecured.get(`/api/v1/rooms/${room.id}/videos`)
          .then(response => {
            this.$set(room, 'videos', response.data)
            console.log(room)
            if (room.videos.length > 0) {
              this.newVideo.name = room.videos[0].name
              this.newVideo.url = room.videos[0].url
              this.newVideo.description = room.videos[0].description
            }
          })
          .catch(error => {
            console.error(`Erro ao encontrar o vídeo da sala ${room.id}:`, error)
          })
      })
    },
    loadVideo (room) {
      this.$httpSecured.get(`/api/v1/rooms/${room.id}/videos`)
        .then(response => {
          this.$set(room, 'videos', response.data)
          console.log(room)
          if (room.videos.length > 0) {
            this.newVideo.name = room.videos[0].name
            this.newVideo.url = room.videos[0].url
            this.newVideo.description = room.videos[0].description
          }
        })
        .catch(error => {
          console.error(`Erro ao encontrar o vídeo da sala ${room.id}:`, error)
        })
    },
    handleVideo (room) {
      const value = { ...this.newVideo }
      if (!value.name || !value.url) {
        return
      }

      if (room.videos) {
        value.id = room.videos[0].id
      }

      if (value.id) {
        const updatedVideo = { id: value.id, name: value.name || '', url: value.url || '', description: value.description || '' }
        this.$httpSecured.put(`/api/v1/rooms/${room.id}/videos/${value.id}`, updatedVideo)
          .then(() => {
            room.videos[0] = updatedVideo
            room.newVideo = {}
            this.loadVideo(room)
          }).catch(error => this.setError(error, 'Não foi possível atualizar as informações do vídeo')
          )
      } else {
        this.$httpSecured.post(`/api/v1/rooms/${room.id}/add_video`, { name: value.name || '', url: value.url || '', description: value.description || '' })
          .then((response) => {
            if (!room.hasOwnProperty('videos')) {
              this.$set(room, 'videos', [])
            }
            const video = response.data.video
            room.videos = []
            room.videos.push(video)
            room.newVideo = {}
            this.loadVideos()
          }).catch(error => this.setError(error, 'Não foi possível adicionar o vídeo à sala'))
      }
    },
    getVideoId (url) {
      const videoIdRegex = /^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([\w-]{11})/
      const match = url.match(videoIdRegex)
      return match ? match[1] : ''
    },
    generateAccessLink (room) {
      const accessLink = `${window.location.origin}/rooms/${room.id}/access/${room.access_code}`
      console.log(accessLink)
    }
  }
}
</script>

<style>
ul {
  list-style: none
}

.form-group {
  /* margin-top: 15px; */
}

.form {
  margin-bottom: 20px;
}

.title {
  font-size: 24px;
  margin-bottom: 20px;
}

.input {
  padding: 5px;
  width: 27%;
  border-radius: 3px;
  border: 1px solid #ccc;
}

.submit-button {
  background-color: #1e6711;
  color: #fff;
  padding: 10px 20px;
  margin: 14px 1px -5px 1px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.add-edit-button {
  background-color: #1e6711;
  color: #fff;
  padding: 5px 15px;
  margin: 14px 1px -5px 1px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.access-button {
  background-color: #e26911;
  text-decoration: none;
  font-size: 14px;
  color: #fff;
  padding: 10px 20px;
  margin: 14px 1px -5px 1px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.label {
  font-weight: bold;
  margin-bottom: 5px;
}
</style>
