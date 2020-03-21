class NameStore {

    storeName(room, name) {
        localStorage.setItem('name_in_' + room, name)
    }

    getName(room) {
        return localStorage.getItem('name_in_' + room)
    }
}

export default new NameStore();