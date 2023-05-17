<template>
  <div>
    <div v-if="error">{{ error }}</div>
    <h3>Criar Sala</h3>
    <form action="" @submit.prevent="addRoom">
      <div>
        <input class="input" autofocus autocomplete="off" placeholder="Crie um nome para sua sala"
          v-model="newRoom.name" />
        <input class="input" autofocus autocomplete="off" placeholder="Adicione uma descrição"
          v-model="newRoom.description" />
      </div>
      <input type="submit" value="Criar sala" />
    </form>

    <ul>
      <li v-for="room in rooms" :key="room.id" :room="room">
      <div>
          <p>{{ room.name }}</p>
          <button @click.prevent="editRoom(room)">Editar</button>
          <button @click.prevent="removeRoom(room)">Excluir</button>
          <router-link :to="`/rooms/${room.id}/access/${room.access_code}`">Acessar sala</router-link>
        </div>
        <div v-for="video in room.videos" :key="video.id">
          <div>{{ video.name }}</div>
          <div>{{ video.description }}</div>
          <youtube :video-id="getVideoId(video.url)"></youtube>
        </div>
        <form @submit.prevent="handleVideo(room)">
          <div>
            <input class="input" v-model="newVideo.name" placeholder="Nome do vídeo" />
            <input class="input" v-model="newVideo.url" placeholder="URL do vídeo" />
            <input class="input" v-model="newVideo.description" placeholder="Descrição do vídeo" />
            <input type="submit" value="Adicionar/Editar" />
          </div>
        </form>
        <div v-if="room == editedRoom">
          <form action="" @submit.prevent="updateRoom(room)">
            <div>
              <input class="input" v-model="room.name" />
              <input class="input" v-model="room.description" />
              <input type="submit" value="Atualizar">
            </div>
          </form>
        </div>
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
      newVideo: {}
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
        })
        .catch(error => this.setError(error, 'Não é possível deletar a sala'))
    },
    editRoom (room) {
      this.editedRoom = room
    },
    updateRoom (room) {
      this.editedRoom = ''
      this.$httpSecured.patch(`/api/v1/rooms/${room.id}`, { room: { name: room.name, description: room.description } })
        .catch(error => this.setError(error, 'Não foi possível atualizar a informação da sala'))
    },
    loadVideos () {
      this.rooms.forEach(room => {
        this.$httpSecured.get(`/api/v1/rooms/${room.id}/videos`)
          .then(response => {
            this.$set(room, 'videos', response.data)
          })
          .catch(error => {
            console.error(`Erro ao encontrar o vídeo da sala ${room.id}:`, error)
          })
      })
    },
    handleVideo (room) {
      const value = { ...this.newVideo }
      if (!value.name || !value.url) {
        return
      }

      if (value.name !== '') {
        const updatedVideo = { id: value.id, name: value.name || '', url: value.url || '', description: value.description || '' }
        this.$httpSecured.put(`/api/v1/rooms/${room.id}/videos/${value.id}`, updatedVideo)
          .then(() => {
            const videoIndex = room.videos.findIndex((video) => video.id === value.id)
            if (videoIndex !== -1) {
              room.videos[videoIndex] = updatedVideo
            }
            room.newVideo = {}
          }).catch(error => this.setError(error, 'Não foi possível atualizar as informações do vídeo')
          )
      } else {
        this.$httpSecured.post(`/api/v1/rooms/${room.id}/add_video`, { name: value.name || '', url: value.url || '', description: value.description || '' })
          .then((response) => {
            if (!room.hasOwnProperty('videos')) {
              this.$set(room, 'videos', [])
            }

            const video = response.data.video
            room.videos.push(video)
            room.newVideo = {}
          }).catch(error => this.setError(error, 'Não foi possível adicionar o vídeo à sala'))
      }
    },
    getVideoId (url) {
      const videoIdRegex = /^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([\w-]{11})/
      const match = url.match(videoIdRegex)
      return match ? match[1] : ''
    }
  }
}
</script>
