---
created_at:  "2018-03-08"
---

# get in touch with vue

I've been recently asked to build up a little `vue` example. 
The task is, to show appointments from a google calendar.
I know some `react` stuff, but the `vue` framework and the google api was new for me.
So I start with some digging.

First things first.
The `vue` example will be a client only solution.
As like `create-react-app`, I use [vue-cli][vuecli] to bootstrap my application.

<!--more-->

# editor preparation

I use vim on a daily base.
Editing `vue` files is similar to editing `react` files.
You can have a mixture of javascript and templates.
There is a [vim plugin][vimvue], 

    Plugin 'posva/vim-vue'

which helps editing `vue` files.
I also update the linter, to get error information from [syntastic][syntastic]

     $ npm i -g eslint eslint-plugin-vue

# set up the development stack

After installing the vue cli tool,

    $ npm install -g @vue/cli

I can bootstrap my `appointment` application with 

    $ vue create appointment

A git repo is initialized with the current logged on user credentials.

With

    $ npm run build

a minified version of the application is put into the `dist` folder.

    $ npm run serve 
    
will build and run the application on port `8080`.
This will be used during development.

# google api

To get access to the google calendar, I have to create a project in the [google developer console][developerconsole].
I need an `oauth2 id` for my application.
The `authorized javascript sources` must be configured for the `oauth2 id`.
The [example][example] from the [google api documentation][googleapidocumentation] works as expected.

# root component

The `data` is stored in `eventResult`.

    data: function() {
        return { eventResult : [] } 
    }

The root component will hold the state of `appointment`.

    const CLIENT_ID = process.env.VUE_APP_CLIENT_ID; 
    const DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"];
    const SCOPES = "https://www.googleapis.com/auth/calendar.readonly";

The `process.env` part will be [replaced][environment] during build process with the actual client id.
A vue component can have [methods][methods], which are accessible in [lifecycle hook functions][hook]

    gapiLoad: function() {
      gapi.load('client:auth2', this.initClient)
    }

will load the client and the oauth part of the google api.

The `initClient` function is passed with the credentials.

    initClient: function() {
      gapi.client.init({
      clientId: CLIENT_ID,
      discoveryDocs: DISCOVERY_DOCS,
      scope: SCOPES
      }).then(() => { 
          gapi.auth2.getAuthInstance().isSignedIn.listen(this.signedIn);
          // get signed in status on startup
          this.signedIn(gapi.auth2.getAuthInstance().isSignedIn.get());
      })
    }

The `signedIn` function will load the data from the google api,

    signedIn: function(isSignedIn) {
        if (isSignedIn) {
            gapi.client.calendar.events.list({
              'calendarId': 'primary',
              'timeMin': (new Date().toISOString(),
              'showDeleted': false,
              'singleEvents': true,
              'maxResults': 10,
              'orderBy': 'startTime'
            }).then((response) => {
              this.eventResult = response.result.items;
            })  
        } else {
            this.eventResult = []; 
        }
    } 

and stores the result in `eventResult`.

These functions will be triggered after the component is [mounted][mount].

    mounted: function() {
      this.gapiLoad();
    }

At this point the data will be fetched, if the user gives the permission to load data from his primary calendar.

# Display component

The data for the component will be delivered via [props][props].
The component it self will be stateless.
This means, the component depends only on the props, delivered on start up.
When the underlying data changes, the view will rerender.

For the visual, I use [vue material][vuematerial].
The display component will be a simple table with some data from the [response][eventlistresponse].
For displaying dates, I use [momentjs][momentjs].
I first create a method, to make `momentjs` accessible within the template.


    methods: {
      moment: function () {
        return moment();
      }
    }

To reduce the amount of code within the templates, [filters][filters] can be used.

    filters: {
      moment: function (date) {
        if (date) {
          return moment(date).locale('en').format('lll');
        }
        return '';
      }
    }

`moment` will be called, only when `date` is not empty.

The resulting template looks like

    <template>
      <div>
        <md-table v-model="gridData" md-card>
          <md-table-toolbar>
            <h1 class="md-title">Events</h1>
          </md-table-toolbar>
    
          <md-table-row slot="md-table-row" slot-scope="{ item }">
            <md-table-cell md-label="Start">{{ item.start.dateTime | moment }}</md-table-cell>
            <md-table-cell md-label="End">{{ item.end.dateTime | moment }}</md-table-cell>
            <md-table-cell md-label="Created">{{ item.created | moment }}</md-table-cell>
            <md-table-cell md-label="Summary"><a :href="item.htmlLink" target="_blank">{{ item.summary }}</a></md-table-cell>
            <md-table-cell md-label="Creator">{{ item.creator.displayName }}</md-table-cell>
            <md-table-cell md-label="Organizer">{{ item.organizer.displayName }}</md-table-cell>
         </md-table-row>
        </md-table>
      </div>
    </template>

If you like, you can take a look at the [result][result] and at the [sources][appointmentsources].

[vuecli]: https://github.com/vuejs/vue-cli
[syntastic]: https://github.com/vim-syntastic/syntastic
[vimvue]: https://github.com/posva/vim-vue
[developerconsole]: https://console.developers.google.com
[example]: https://developers.google.com/google-apps/calendar/quickstart/js
[googleapidocumentation]: https://developers.google.com/google-apps/calendar
[environment]: https://github.com/vuejs/vue-cli/blob/dev/docs/env.md
[hook]: https://vuejs.org/v2/guide/instance.html#Instance-Lifecycle-Hooks
[methods]: https://vuejs.org/v2/guide/events.html#Method-Event-Handlers
[mount]: https://vuejs.org/v2/api/#mounted
[eventlistresponse]: https://developers.google.com/google-apps/calendar/v3/reference/events/list
[momentjs]: https://momentjs.com
[filters]: https://vuejs.org/v2/guide/filters.html#ad
[vuematerial]: https://vuematerial.io
[props]: https://vuejs.org/v2/guide/components.html#Props
[result]: /example/vue/index.html
[appointmentsources]: https://github.com/enter-haken/appointment
