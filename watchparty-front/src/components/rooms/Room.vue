<template>
  <div>
    <div v-if="error">{{ error }}</div>
    <h3>Criar Sala</h3>
    <form action="" @submit.prevent="addRoom">
      <div>
        <input class="input" autofocus autocomplete="off" placeholder="Crie um nome para sua sala" v-model="newRoom.name" />
        <input class="input" autofocus autocomplete="off" placeholder="Adicione uma descrição" v-model="newRoom.description" />
        <input class="input" autofocus autocomplete="off" placeholder="Código de Acesso" v-model="newRoom.access_code" />
      </div>
      <input type="submit" value="Criar sala" />
    </form>

    <ul>
      <li v-for="room in rooms" :key="room.id" :room="room">
        <div>
          <p>{{ room.name }}</p>
          <button @click.prevent="editRoom(room)">Editar</button>
          <button @click.prevent="removeRoom(room)">Excluir</button>
        </div>
        <div v-for="video in videos" :key="video.id">
          <div>{{ video.name }}</div>
          <div>{{ video.description }}</div>
          <youtube :video-id="getVideoId(video.url)"></youtube>
        </div>
        <div v-if="room == editedRoom">
          <form action="" @submit.prevent="updateRoom(room)">
            <div>
              <input class="input" v-model="room.name" />
              <input class="input" v-model="room.description" />
              <input class="input" v-model="room.access_code" />
              <input type="submit" value="Atualizar">
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>

import Youtube from 'vue-youtube'

export default {
  name: 'Rooms',
  components: {
    Youtube
  },
  props: ['videos'],
  data () {
    return {
      rooms: [],
      newRoom: [],
      error: '',
      editedRoom: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$httpSecured.get('/api/v1/rooms')
        .then(response => { this.rooms = response.data })
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
      this.$httpSecured.post('/api/v1/rooms/', { room: { name: this.newRoom.name, description: this.newRoom.description, access_code: this.newRoom.access_code } })
        .then(response => {
          this.rooms.push(response.data)
          this.newRoom = ''
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
      this.$httpSecured.patch(`/api/v1/rooms/${room.id}`, { room: { name: room.name, description: room.description, access_code: room.access_code } })
        .catch(error => this.setError(error, 'Não foi possível atualizar a informação da sala'))
    },
    getVideoId (url) {
      // Extrair o ID do vídeo a partir da URL do YouTube
      // Implemente a lógica aqui para extrair o ID do vídeo da URL
    }
  }
}
</script>
