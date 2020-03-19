<template>
<div>
    <button v-on:click="raiseHand">Raise hand</button>
    <h2>List of connected users</h2>
    <ul>
        <li v-for="name in connectedUsers">
            {{name}}
        </li>
    </ul>
</div>
</template>

<script>
    import socket from "../socket"
    import {Presence} from "phoenix"

    let name = "Charles_" + Math.floor(Math.random() * 10);

    export default {
        data() {
            return {
                connectedUsers: [],
                channel: null
            }
        },
        watch: {
            $route(to, from) {
                this.joinChannel(this.$route.params.id)
            }
        },
        mounted() {
            this.joinChannel(this.$route.params.id)
        },
        methods: {
            raiseHand() {
                this.channel.push("raise_hand")
            },
            joinChannel(channelName) {
                if(this.channel) {
                    this.channel.leave()
                }

                this.channel = socket.channel("room:" + this.$route.params.id, {name: name})

                let presence = new Presence(this.channel)

                presence.onSync(() => {
                    this.connectedUsers = []

                    presence.list((id, {metas: [user, ...rest]}) => {
                        this.connectedUsers.push(user.name)
                    })
                })

                this.channel.on("hand_raised", payload => {
                    console.log(payload)
                })

                this.channel.join()
                    .receive("ok", resp => { console.log("Joined successfully", resp) })
                    .receive("error", resp => { console.log("Unable to join", resp) })
            }

        }
    }
</script>