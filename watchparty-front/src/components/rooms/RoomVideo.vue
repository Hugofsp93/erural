<template>
  <div>
    <h3>WatchParty</h3>
  </div>
</template>

<script>

export default {
  name: 'RoomVideo',
  data () {
    return {
      room: null
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
    }
  }
}
</script>
