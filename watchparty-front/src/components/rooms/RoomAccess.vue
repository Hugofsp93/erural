<template>
  <div>
    <h3>Acessar Sala</h3>
    <form @submit.prevent="accessRoom">
      <div>
        <input type="hidden" v-model="roomId" />
        <input class="input" v-model="accessCode" placeholder="Código de Acesso" />
        <input type="submit" value="Acessar" />
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: 'RoomAccess',
  data () {
    return {
      roomId: this.$route.params.id,
      accessCode: ''
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    accessRoom () {
      this.$http.get(`/api/v1/rooms/${this.roomId}/access/${this.accessCode}`)
        .then(response => {
          this.$router.push(`/rooms/${this.roomId}`)
        })
        .catch(error => this.setError(error, 'Não foi possível acessar a sala!'))
    }
  }
}
</script>
