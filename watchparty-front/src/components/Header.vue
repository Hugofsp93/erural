<template>
  <header>
    <div>
      <div>
        <title>E-Rural</title>
        <a href="/">E-Rural</a>
      </div>
      <div>
        <router-link to="/rooms" v-if="signedIn()">Salas</router-link>
        <a href="#" @click.prevent="signOut" v-if="signedIn()">Deslogar</a>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'Header',
  created () {
    this.signedIn()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signedIn () {
      return localStorage.signedIn
    },
    signOut () {
      this.$httpSecured.delete('/signin')
        .then(response => {
          delete localStorage.csrf
          delete localStorage.signedIn
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Não foi possível deslogar'))
    }
  }
}
</script>
