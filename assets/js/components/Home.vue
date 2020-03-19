<template>
    <div>
        <form class="join-form" @submit.prevent="onSubmit">
            <p>
                <label for="name">Name:</label>
                <input id="name" v-model="name" placeholder="name">
            </p>

            <p>
                <label for="group">Group:</label>
                <input id="group" v-model="group" placeholder="group">
            </p>

            <p>
                <input type="submit" value="Submit">
            </p>

        </form>

    </div>
</template>

<script>
    export default {
        data: () => {
            return {
                name: "",
                group: ""
            }
        },
        methods: {
            onSubmit: () => {
                console.log('submit')
            }
        }
    }
</script>