<template>
  <div>
    <div v-if="error">{{ error }}</div>
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
      accessCode: '',
      room: null,
      error: ''
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    accessRoom () {
      this.$httpSecured.get(`/api/v1/rooms/${this.roomId}/access/${this.accessCode}`)
        .then(response => {
          if (response.data.success === true) {
            this.$router.push(`/rooms/${this.roomId}`)
          } else {
            this.setError(response, 'Código de acesso incorreto!')
          }
        })
        .catch(error => this.setError(error, 'Não foi possível acessar a sala!'))
    }
  }
}
</script>
