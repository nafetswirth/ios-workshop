module.exports = {
    configureHandlers: configureHandlers
}

function configureHandlers(socket) {
    
    Task.find()
        .then(function(tasks) {
            var ids = _.pluck(tasks, 'id');
            //receives broadcasting messages for publishCreate
            Task.watch(socket, ids);
            //received broadcasting messages for publishUpdate/pusblishDestroy
            Task.subscribe(socket, ids);
        });
}
