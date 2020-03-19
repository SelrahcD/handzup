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

    let channel = null;
    let presence = null;
    export default {
        data: () => {
            return {
                connectedUsers: []
            }
        },
        mounted() {
            channel = socket.channel("room:" + this.$route.params.id, {name: "Charles_" + Math.floor(Math.random() * 10)})
            presence = new Presence(channel)

            channel.join()
                .receive("ok", resp => { console.log("Joined successfully", resp) })
                .receive("error", resp => { console.log("Unable to join", resp) })

            channel.on("hand_raised", payload => {
                console.log(payload)
            })

            presence.onSync(() => {
                this.connectedUsers = []

                presence.list((id, {metas: [user, ...rest]}) => {
                    this.connectedUsers.push(user.name)
                })
            })

        },
        methods: {
            raiseHand: () => {
                channel.push("raise_hand")
            },

        }
    }
</script>