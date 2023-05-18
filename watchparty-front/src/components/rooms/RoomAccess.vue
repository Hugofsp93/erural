<template>
  <div>
    <div v-if="error">{{ error }}</div>
    <h3 class="title">Digite o código informado para entrar na sala</h3>
    <form @submit.prevent="accessRoom">
      <input type="hidden" v-model="roomId" />
      <div class="form-group">
        <input class="input" v-model="accessCode" placeholder="Código de Acesso" />
      </div>
      <button type="submit" class="submit-button">Acessar</button>
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

<style>
.title {
  font-size: 24px;
  margin-bottom: 20px;
}

.error {
  color: red;
  margin-bottom: 10px;
}

.label {
  font-weight: bold;
  margin-bottom: 5px;
}

.input {
  padding: 5px;
  width: 100%;
  border-radius: 3px;
  border: 1px solid #ccc;
  width: 30%;
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
</style>
