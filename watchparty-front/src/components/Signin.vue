<template>
  <div class="login-container">
    <div class="login-form">
      <h3 class="title">Login</h3>
      <form @submit.prevent="signin" class="form">
        <div v-if="error" class="error">{{ error }}</div>
        <div class="form-group">
          <label for="email" class="label">E-mail</label>
          <input type="email" v-model="email" class="input" id="email" placeholder="seuemail@gmail.com">
        </div>
        <div class="form-group">
          <label for="password" class="label">Senha</label>
          <input type="password" v-model="password" class="input" id="password" placeholder="senha">
        </div>
        <button type="submit" class="submit-button">Login</button>
        <div class="signup-link"><router-link to="/signup">Cadastre-se</router-link></div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$httpPlain.post('/signin', { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      window.location.reload()
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/rooms')
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
}

.form-group {
  margin-top: 15px;
}

.login-form {
  min-width: 400px;
  max-width: 400px;
  padding: 20px;
  background-color: #f0f0f0;
  border-radius: 5px;
}

.title {
  font-size: 24px;
  margin-bottom: 20px;
}

.form {
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

.signup-link {
  margin-top: 10px;
  float: right;
}

.signup-link a {
  color: #1e6711;
  text-decoration: none;
  font-size: 12px;
}
</style>
