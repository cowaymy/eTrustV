<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
  var option = {
    width : "1200px",
    height : "500px"
  };

  var ItmOption = {
          type : "S",
          isCheckAll : false
  };

  var myGridID;

  var gridPros = {
          usePaging : true,
          pageRowCount : 20,
          editable : false,
          selectionMode : "multipleCells"
        };

  $(document).ready(function() {
        sroForecastHistoryGrid();
        doGetComboData('/logistics/totalstock/selectCDCList.do', '', '','searchCDC', 'S' , '');
        doGetComboData('/logistics/stockReplenishment/selectSroLocationType.do', null, '', 'searchlocgb', 'M','f_multiCombo');
        doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiComboType');
        doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiComboType');
        doGetComboData('/logistics/totalstock/selectTotalBranchList.do','', '', 'searchBranch', 'S','');
        CommonCombo.make('searchWeek', "/logistics/stockReplenishment/selectWeekList.do", null , '', ItmOption);
        doGetComboData('/logistics/stockReplenishment/selectSroStatus.do', null, '', 'searchStatus', 'M','f_multiCombo');
        CommonCombo.make('searchYear', "/logistics/stockReplenishment/selectYearList.do", null , '', ItmOption);
        CommonCombo.make('searchMonth', "/logistics/stockReplenishment/selectMonthList.do", null , '', ItmOption);


   });

  $(function(){
      $('#search_sroStorageDeliveryForm').click(function() {
          if (f_validatation()){
              fn_searchSroForecastHistortList();
          }
      });
      $('#clear').click(function() {
          $('#searchMatCode').val('');
          $('#searchMatName').val('');
          doGetCombo('/common/selectCodeList.do', '15', '', 'searchType', 'M','f_multiComboType');
          doGetCombo('/common/selectCodeList.do', '11', '','searchCtgry', 'M' , 'f_multiCombos');
          doGetComboData('/logistics/stockReplenishment/selectSroLocationType.do', null, '', 'searchlocgb', 'M','f_multiCombo');
          doGetComboData('/logistics/stockReplenishment/selectSroStatus.do', null, '', 'searchStatus', 'M','f_multiCombo');
      });

      $('#searchMatName').keypress(function(event) {
          $('#searchMatCode').val('');
          if (event.which == '13') {
              $("#stype").val('stock');
              $("#svalue").val($('#searchMatName').val());
              $("#sUrl").val("/logistics/material/materialcdsearch.do");
              Common.searchpopupWin("sroStorageDeliveryForm", "/common/searchPopList.do","stock");
          }
      });


      $("#sroStorageDeliveryFormBranch").change(function(){
          if(($('#searchlocgb').val() == "04") && ($('#searchBranch').val() != "")){
              console.log("choose cody and branch is selected.");
              var paramdata = {
                      searchBranch : $("#searchBranch").val(),
                      locgb : 'CT'
                  };
              doGetComboData('/common/selectStockLocationList.do', paramdata , '', 'searchLoc', 'M','f_multiComboType');
          }
      });
  });

  function sroForecastHistoryGrid() {
    var columnLayout = [
          {
            dataField : "foreYyyy",
            headerText : "Year",
            editable : false,
            width : 100
          },
          {
            dataField : "foreMm",
            headerText : "Month",
            editable : false,
            width : 150
          },
          {
            dataField : "foreWw",
            headerText : "Week",
            width : 100
          },
          {
            dataField : "rdcCode",
            headerText : "Branch Code",
            width : 150
          },
          {
            dataField : "rdcDesc",
            headerText : "Branch Name",
            width : 200
          },
          {
            dataField : "codyCode",
            headerText : "Location Code",
            editable : false,
            width : 150
          },
          {
            dataField : "codyDesc",
            headerText : "Location Name",
            editable : false,
            width : 250
          },
          {
            dataField : "stkCode",
            headerText : "Code",
            editable : false,
            width : 150
          },
          {
            dataField : "stkDesc",
            headerText : "Desc",
            editable : false,
            width : 150
          },
          {
            dataField : "sroForeQty",
            headerText : "Forecast",
            editable : false,
            width : 150
          },
          {
            dataField : "sroReqDevliQty",
            headerText : "Delivery",
            editable : false,
            width : 150
          },
          {
            dataField : "shortageQty",
            headerText : "Shortage",
            editable : false,
            width : 150
          }
    ];

    myGridID = AUIGrid.create("#grid_wrap_sroStorageDeliveryForm", columnLayout, gridPros);
  }

  function fn_searchSroForecastHistortList() {

        console.log($("#sroStorageDeliveryForm").serialize());
        Common.ajax("GET", "/logistics/stockReplenishment/sroForecastHistoryList.do", $("#sroStorageDeliveryForm").serialize(), function(result) {
        console.log(result);
          AUIGrid.setGridData(myGridID, result);
        });
  }


  function fn_excelDown() {
      var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (date.getDate() < 10) {
          day = "0" + date.getDate();
      }
    GridCommon.exportTo("grid_wrap_sroStorageDeliveryForm", "xlsx", "SroHsFilterForecastRdc_" + day + month + date.getFullYear());
  }

  function f_multiCombo() {
        $(function() {
               $('#searchlocgb').change(function() {
                   let flag =$.inArray("04",$("#searchlocgb").val());
                   if (FormUtil.isNotEmpty($('#searchlocgb').val())){
                       if(flag >=0 && FormUtil.isEmpty($('#searchBranch').val())){
                           Common.alert("Please choose Branch to search listing.",()=>{
                               $('.msg_box').remove();
                        });
                       }else{
                               var searchlocgb = $('#searchlocgb').val();
                               var locgbparam = "";

                               for (var i = 0 ; i < searchlocgb.length ; i++){
                                   if (locgbparam == ""){
                                       locgbparam = searchlocgb[i];
                                   }else{
                                       locgbparam = locgbparam +"∈"+searchlocgb[i];
                                   }
                               }
                               var param = {searchlocgb:locgbparam , grade:'A', searchBranch: ($('#searchBranch').val()!="" ? $('#searchBranch').val() : "" )}
                               doGetComboData('/common/selectStockLocationList2.do', param , '', 'searchLoc', 'M','f_multiComboType');
                         }
                   }
               }).multipleSelect({
                   selectAll : true
               });


            $('#searchStatus').change(function() {
            }).multipleSelect({
                selectAll : true
            });

        });
    }

  function f_multiComboType() {
        $(function() {
            $('#searchLoc').change(function() {
            }).multipleSelect({
                selectAll : true
            });

            $('#searchCtgry').change(function() {
            }).multipleSelect({
                selectAll : true
            });


            $('#searchType').change(function() {
            }).multipleSelect({
                selectAll : true
            });
        });
    }

  function fn_itempopList(data){

        var rtnVal = data[0].item;
        console.log(rtnVal);
        if ($("#stype").val() == "stock" ){
            $("#searchMatCode").val(rtnVal.itemcode);
            $("#searchMatName").val(rtnVal.itemname);
        }else{
            $("#searchLoc").val(rtnVal.locid);

        }

        $("#svalue").val();
    }


  $.fn.clearForm = function() {
      return this.each(function() {
          var type = this.type, tag = this.tagName.toLowerCase();
          if (tag === 'form'){
              return $(':input',this).clearForm();
          }
          if (type === 'text' || type === 'password'  || tag === 'textarea'){
              if($("#"+this.id).hasClass("readonly")){

              }else{
                  this.value = '';
              }
          }else if (type === 'checkbox' || type === 'radio'){
              this.checked = false;

          }else if (tag === 'select'){
              if($("#memType").val() != "7"){ //check not HT level
                   this.selectedIndex = 0;
              }
          }
      });
  };


  function f_validatation(){

      if(FormUtil.isEmpty($('#searchYear').val())) {
          Common.alert("Please Select Forecast Year.");
          return false;
       }

      if(FormUtil.isEmpty($('#searchMonth').val())) {
          Common.alert("Please Select Forecast Month.");
          return false;
       }

      return true;
}


</script>
<section id="content">
 <ul class="path"></ul>
 <aside class="title_line">
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>Shortage Delivery Report</h2>

  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="search_sroStorageDeliveryForm"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
   </c:if>
   <li><p class="btn_blue"><a href="#" onclick="javascript:$('#sroStorageDeliveryForm').clearForm();"><span class="clear"></span><spring:message code='service.btn.Clear'/></a></p></li>
  </ul>
 </aside>
 <section class="search_table">
  <form action="#" method="post" id="sroStorageDeliveryForm">
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
    <input type="hidden" id="stype" name="stype">
    <input type="hidden" name="LocCode" id="LocCode" />
   <table class="type1">
    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 170px" />
     <col style="width: *" />
    </colgroup>
    <tbody>

    <tr>
         <th scope="row">Forecast Year</th>
         <td><select class="w100p" id="searchYear"  name="searchYear"></td>

         <th scope="row">Forecast Month</th>
         <td><select class="w100p" id="searchMonth"  name="searchMonth"></td>

         <th scope="row">Forecast Week / Batch</th>
         <td><select class="w100p" id="searchWeek"  name="searchWeek"></td>
      </tr>

       <tr>
             <th scope="row">CDC</th>
             <td><select class="w100p" id="searchCDC" name="searchCDC"></select></td>

             <th scope="row">Branch</th>
             <td><select class="w100p" id="searchBranch"  name="searchBranch"></select></td>

             <th></th>
             <td></td>
         </tr>

     <tr>
         <th scope="row">Location Type</th>
         <td><select id="searchlocgb" name="searchlocgb" class="multy_select w100p"multiple="multiple"></select></td>

         <th scope="row">Location Code</th>
         <td> <select class="w100p" id="searchLoc" name="searchLoc" class="multy_select w100p" multiple="multiple"></select></td>

         <th scope="row">Status</th>
         <td><select id="searchStatus" name="searchStatus" class="multy_select w100p"multiple="multiple"></select></td>
     </tr>

      <tr>
         <th scope="row">Category</th>
         <td><select class="w100p" id="searchCtgry"  name="searchCtgry"></select></td>

         <th scope="row">Type</th>
         <td><select class="w100p" id="searchType" name="searchType"></select></td>

         <th scope="row">Material</th>
         <td>
             <input type="hidden" title="" placeholder=""  class="w100p" id="searchMatCode" name="searchMatCode"/>
             <input type="text"   title="" placeholder=""  class="w100p" id="searchMatName" name="searchMatName"/>
         </td>
     </tr>
    </tbody>
   </table>

   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
      </p></li>
    </c:if>
   </ul>
   <article class="grid_wrap">
    <div id="grid_wrap_sroStorageDeliveryForm" style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
  </form>

 </section>
</section>
