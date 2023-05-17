<template>
  <header>
    <div class="header-container">
      <img src="../assets/logo.svg" alt="Image description" class="logo">
      <div class="title-wrapper">
        <router-link to="/" class="home-link">WatchParty eRural</router-link>
      </div>
      <div class="nav-links">
        <router-link to="/rooms" v-if="signedIn()" class="nav-link">Salas</router-link>
        <a href="#" @click.prevent="signOut" v-if="signedIn()" class="nav-link">Deslogar</a>
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

<style scoped>
.header-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0px 30px;
  background-color: #0d2c07;
}

.logo {
  width: 100px;
  height: 100px;
}

.title-wrapper {
  display: flex;
  align-items: center;
}
.home-link {
  font-size: 20px;
  text-decoration: none;
  color: #fff;
  margin-right: -2rem;
}

.nav-links {
  display: flex;
  align-items: center;
}

.nav-link {
  font-size: 20px;
  text-decoration: none;
  color: #fff;
  margin-left: 2rem;
}
</style>
