(function() {
    'use strict';

    /**
     * @ngdoc function
     * @name adminDashboardApp.controller:MainCtrl
     * @description
     * # MainCtrl
     * Controller of the adminDashboardApp
     */
    angular.module('todoApp')
        .controller('TaskListCtrl', [
            '$sails',
            '$resource',
            'tasks',
            TaskListController
        ]);



    function TaskListController($sails, $resource, tasks) {
        var vm = this;
        vm.tasks = tasks;
        vm.createTask = createTask;
        vm.deleteTask = deleteTask;

        var taskResource = $resource('https://ios-workshop.herokuapp.com/task/:id', {id: '@id'});

        $sails.on('task', handleSocketMessage);

        function createTask(opts) {
            taskResource.save({
                name: 'Task',
                dueTo: new Date().toISOString()
            })
            .$promise
            .then(function(task) {
                //luvly oneliner
                if(vm.tasks.map(function(task) {return task.id}).indexOf(task.id) !== -1) {
                    return;
                }
                vm.tasks.push(task);
            });
        }

        function deleteTask(task) {
            taskResource.delete({id: task.id})
                .$promise
                .then(function(deletedTask) {
                    vm.tasks = vm.tasks.filter(function(task) {
                        return task.id !== deletedTask.id;
                    });
                });
        }

        function handleSocketMessage(message) {
            if(message.verb !== 'created' && message.verb !== 'updated') {
                return;
            }

            if(message.verb === 'created') {
                if(vm.tasks.map(function(task) {return task.id}).indexOf(message.data.id) !== -1) {
                    return;
                }
                vm.tasks.push(message.data);
            } else if(message.verb === 'destroyed') {
                vm.tasks = vm.tasks.filter(function(task) {
                    return task.id !== message.previous.id;
                });
            }
        }
    };
}());