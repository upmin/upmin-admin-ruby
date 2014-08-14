var Models = {
  init: function() {
    return console.log("Init Models JS...");
  },


  Search: {
    init: function() {
      console.log("Init Models.Search JS...");

      // Get Data
      var algoliaData = $('.data-container .algolia-data');
      var algoliaApiKey = algoliaData.data('api-key');
      var algoliaIndex = algoliaData.data('index');


      // Init Algolia
      var algolia = new AlgoliaSearch('DKIKT3BRHR', algoliaApiKey);
      // var index = algolia.initIndex(algoliaIndex);
      var helper = new AlgoliaSearchHelper(algolia, algoliaIndex, {
        // list of conjunctive facets (link to refine)
        facets: [],

        // list of disjunctive facets (checkbox to refine)
        disjunctiveFacets: ['upmin_model'],

        // number of results per page
        hitsPerPage: 10
      });
      this.helper = helper;


      // Setup dom objects we will need to interact with.
      var $q = $('#q');
      var $searchResults = $('.search-result');

      // Input bindings
      var lastQuery = $q.val();
      $q.on('keyup change', function() {
        if($q.val() != lastQuery) {
          lastQuery = $q.val();
          helper.setPage(0);
          helper.clearRefinements();
          search();
        }
      }).focus();

      // Pagination bindings
      $('#pagination').on('click', '.pagination li:not(.disabled) a', function(e) {
        var $clicked = $(e.target);
        var page = $clicked.data('page');
        helper.gotoPage(page);
      });

      // perform a search
      function search() {
        var params = {
        };

        // perform the query
        helper.search($q.val(), handleSearchResults, params);
      } // end of search()


      function handleSearchResults(success, content) {
        if(!success || content.query != $q.val()) {
          // Search query changed, or something fucked up and there is an error.
          return;
        }

        // Fill in results we are using.
        for(var i = 0; i < content.hits.length && i < 10; i++) {
          renderSearchResult(
            content.hits[i],
            $searchResults[i]
          );
        }

        // Hide results no longer being used.
        if(content.hits.length < 10) {
          for(var i = content.hits.length; i < 10; i++) {
            $($searchResults[i]).addClass("hidden");
          }
        }

        renderPagination(content.page, content.nbPages);

        // TODO(jon): Add facet filtering


      } // end of handleSearchResults();

      function findModelColor(model_name) {
        return $('.models-data').find('.model.' + model_name).data('color');
      } // end of findModelColor()

      // TODO(jon): Update the jetty_model to upmin_model after testing
      function renderSearchResult(hit, searchResult) {
        var $searchResult = $(searchResult);
        var $a = $searchResult.parent('a.search-result-link');
        var rootPath = $('body').data('root-path');
        $a.attr('href', rootPath + 'models/' + hit.jetty_model + '/' + hit.id);

        // Find the icon-outer, remove classes - most notably the color class
        // then add the classes we need back - icon-outer and the new color.
        $searchResult.find('.icon-outer')
          .removeClass()
          .addClass('icon-outer')
          .addClass(findModelColor(hit.jetty_model));

        $searchResult.find('.icon-letter').text(hit.jetty_model[0]);
        $searchResult.find('.icon-name').text(hit.jetty_model);
        $searchResult.find('.icon-id').text(hit.id);

        var dl = $searchResult.find('dl.dl-horizontal');
        dl.html('');

        $.each(Object.keys(hit), function(index, key) {
          if(key == "_highlightResult" || key == "objectID" ||
             key == "id" || key == "jetty_model") {
            return;
          }

          var val = hit[key];
          if(hit._highlightResult[key]) {
            val = hit._highlightResult[key].value;
          }
          dl.append(
            '<dt>' + key + '</dt>' +
            '<dd>' + val + '</dd>'
          );
        });

        $searchResult.removeClass("hidden");
      } // end of renderSearchResult()

      function renderPagination(page, numPages) {
        var $pagination = $('ul.pagination');
        $pagination.html('');

        // Prev Page
        $pagination.append(
          '<li class="prev-page">' +
            '<a href="#">&laquo;</a>' +
          '</li>'
        );
        if(page > 0) {
          $pagination.find('.prev-page a').data('page', (page - 1));
        } else {
          $pagination.find('.prev-page').addClass('disabled');
        }

        // Num Pages
        var start = Math.max(0, page - 4);
        var prevPages = Math.min(4, start);
        var end = Math.min(numPages, page + 9 - prevPages);
        if(numPages <= 9) {
          start = 0; end = numPages;
        }

        for(var i = start; i < end; i++) {
          var active = "";
          if(i == page) {
            active = "active";
          }
          $pagination.append(
            '<li class="' + active + '">' +
              '<a href="#" data-page="' + i + '">' +
                (i+1) +
              '</a>' +
            '</li>'
          );
        }

        // Next Page
        $pagination.append(
          '<li class="next-page">' +
            '<a href="#">&raquo;</a>' +
          '</li>'
        );
        if(page < numPages - 1) {
          $pagination.find('.next-page a').data('page', (page + 1));
        } else {
          $pagination.find('.next-page').addClass('disabled');
        }

      } // end of renderPagination()


      function renderFacets() {
        // TODO(jon): Implement this.
      } // end of renderFacets()




      // Search so we have results with no query.
      search();
    }, // end of Search.init()

  } // end of Search




};

if (window.Upmin == null) {
  window.Upmin = {};
}

window.Upmin.Models = Models;
