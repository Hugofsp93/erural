<template>
  <div>
    <router-link to="/rooms" class="back-button">Voltar</router-link>
    <div class="basic-infos">
      <h3 class="title">WatchParty</h3>
      <p class="label">Sala de {{ room.name_user }}</p>
    </div>
    <div v-if="error">{{ error }}</div>
    <div class="infos" v-if="room">
      <p class="title">{{ room.name }}</p>
      <p class="label">{{ room.description }}</p>
    </div>
    <div class="info-video" v-if="room.videos">
      <p class="label">{{ room.videos.name }}</p>
      <p class="label">{{ room.videos.description }}</p>
      <youtube :video-id="getVideoId(room.videos.url)" class="youtube-video"></youtube>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import VueYouTubeEmbed from 'vue-youtube-embed'
Vue.use(VueYouTubeEmbed)

export default {
  name: 'RoomVideo',
  data () {
    return {
      room: null,
      error: ''
    }
  },
  mounted () {
    this.fetchRoomData()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    fetchRoomData () {
      this.$httpSecured.get(`/api/v1/rooms/${this.$route.params.id}`)
        .then(response => {
          this.room = response.data
        })
        .catch(error => {
          console.error('Erro ao buscar informações da sala:', error)
        })
    },
    getVideoId (url) {
      const videoIdRegex = /^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([\w-]{11})/
      const match = url.match(videoIdRegex)
      return match ? match[1] : ''
    }
  }
}
</script>

<style>
.basic-infos {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.infos {
  /* display: flex; */
}

.info-video {
  /* display: flex; */
}

.label {
  font-weight: bold;
  margin-bottom: 5px;
}

.title {
  font-size: 24px;
  margin-bottom: -10px;
}

.back-button {
  position: absolute;
  color: #1e6711;
  text-decoration: none;
  font-size: 16px;
  margin: 3px;
}

.youtube-video {
  text-align: center;
}
</style>
