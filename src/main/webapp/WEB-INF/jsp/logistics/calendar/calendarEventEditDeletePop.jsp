<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    var calGridID;

    $(document).ready(function() {
    	createAUIGrid();

    	$("#calSearchBtn").click(function() {
    		fn_getCalSearchResultJsonList();
    	});

    });

    function fn_getCalSearchResultJsonList() {
    	Common.ajax("GET", "/logistics/calendar/searchCalendarEvents.do", $("#calSearchEditDeleteForm").serialize(), function(result){
    		AUIGrid.setGridData(calGridID, result);
    	});
    }

    function createAUIGrid() {
    	var calColumnLayout = [
    	       {dataField: "eventId", headerText: "Event ID", visible: false, editable: false},
               {dataField: "" ,
    	         width: "10%",
    	         headerText: "",
    	         editable: false,
    	         renderer: {
    	        	  type : "IconRenderer",
    	              iconTableRef :  {
    	            	    "default" : "${pageContext.request.contextPath}/resources/images/common/icon_gabage_s.png"// default
    	              },
    	              iconWidth : 16,
    	              iconHeight : 16,
    	              onclick : function(rowIndex, columnIndex, value, item) {
    	            	    fn_removeItem(item.eventId);
    	              }
    	         }
    	       },
    	       {dataField: "eventDt", headerText: "Date", editable: false, width: "15%"},
    	       {dataField: "memType", headerText: "Member Type", editable: false, width: "20%"},
    	       {dataField: "eventDesc", headerText: "Description", editable: true, width: "50%"}
        ];

    	var gridPros = {
    			usePaging : true,
    			pageRowCount : 20,
    			showRowNumColumn : false
    	};

        calGridID = GridCommon.createAUIGrid("#cal_grid_wrap", calColumnLayout, "eventId", gridPros);
    }

    function fn_removeItem(eventId) {
    	Common.ajax("GET", "/logistics/calendar/updRemoveCalItem.do", {"eventId": eventId}, function(result) {
            Common.alert(result.message, fn_getCalSearchResultJsonList);
    	});
    }

    function fn_saveCalGridMap() {
    	if (fn_validationCheck() == false) {
    		return false;
    	}

        Common.ajax("POST", "/logistics/calendar/saveCalEventChangeList.do", GridCommon.getEditData(calGridID), function(result) {
        	Common.alert(result.message, fn_getCalSearchResultJsonList);
        });
    }

    function fn_validationCheck() {
        var result = true;
        var updList = AUIGrid.getEditedRowItems(calGridID);

        if (updList.length == 0)
        {
          Common.alert("No changes made.");
          return false;
        }

        for (var i = 0; i < updList.length; i++) {
          var eventDesc  = updList[i].eventDesc;

          if (eventDesc == "" || eventDesc.length == 0) {
            result = false;
            // {0} is required.
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Description' htmlEscape='false'/>");
            break;
          }
        }

        return result;
    }

</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='Edit/Delete Calendar Event'/></h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE'/></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body"><!-- pop_body start -->
   <ul class="right_btns mb10">
     <li><p class="btn_blue"><span class="search"></span><a href="#" id="calSearchBtn"><spring:message code="sal.btn.search" /></a></p></li>
   </ul>
   <section class="search_table"><!-- search_table start -->
     <form id="calSearchEditDeleteForm" name="calSearchEditDeleteForm" method="get">
       <table class="type1"><!-- table start -->
         <caption>table</caption>
         <colgroup>
           <col style="width:150px" />
           <col style="width:*" />
         </colgroup>
         <tbody>
           <tr>
             <th scope="row"><spring:message code='cal.search.month'/></th>
             <td colspan='3'><input type="text" id="calMonthYear" name="calMonthYear" title="Month" class="j_date2" placeholder="Choose one" /></td>
           </tr>
           <tr id="rowMemType">
             <th scope="row"><spring:message code='cal.search.memType'/></th>
             <td colspan='3'>
               <select class="" id="calMemType" name="calMemType">
                 <option value="">Choose One</option>
                 <option value="1">Health Planner</option>
                 <option value="2">Coway Lady</option>
                 <option value="4">Staff</option>
                 <option value="7">Homecare Technician</option>
               </select>
             </td>
           </tr>
         </tbody>
       </table><!-- table end -->
     </form>
     <section class="search_result"><!-- search_result start -->
       <ul class="right_btns">
         <li><p class="btn_grid"><a onclick="fn_saveCalGridMap();"><spring:message code='cal.btn.save.editDesc'/></a></p></li>
       </ul>
       <article class="grid_wrap"><!-- grid_wrap start -->
         <div id="cal_grid_wrap" class="autoGridHeight"></div>
       </article><!-- grid_wrap end -->
     </section><!-- search_result end -->
   </section><!-- search_table end -->
 </section>
</div><!-- popup_wrap end -->