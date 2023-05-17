<template>
  <div>
    <div v-if="error">{{ error }}</div>
    <h3>WatchParty</h3>
    <div v-if="room">
      <p>Description: {{ room.description }}</p>
      <p>Name: {{ room.name }}</p>
      <p>User ID: {{ room.name_user }}</p>
      <div v-if="room.videos">
        <p>Video Name: {{ room.videos.name }}</p>
        <p>Video Description: {{ room.videos.description }}</p>
        <youtube :video-id="getVideoId(room.videos.url)"></youtube>
      </div>
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
