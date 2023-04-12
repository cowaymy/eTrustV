<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Logistics</li>
        <li>Cody SRO</li>
        <li>SRO Generate Calendar</li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a class="click_add_on">My menu</a> </p>
        <h2>SRO Generate Calendar</h2>

        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue">
                            <a id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a>
                    </p>
                </li>
            </c:if>
        </ul>
    </aside>

    <section class="search_table">
        <form id="searchForm">
	    <input type="hidden" id="year" name="year"/>
	    <input type="hidden" id="month" name="month"/>
            <table class="type1">
                <caption>search table</caption>
                <colgroup>
                    <col style="width: 110px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.monthYear'/></th>
                        <td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt}" style="width: 200px;" /></td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>

    <section class="search_result">
       <form id="callForm">
           <input type="hidden" name="procedureNm" id="procedureNm"/>
            <ul class="right_btns">
                <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                   <li><p class="btn_grid"><a id="addRow"><spring:message code='sys.btn.add'/></a></p></li>
                   <li><p class="btn_grid"><a id="save"><spring:message code='sys.btn.save'/></a></p></li>
                </c:if>
            </ul>

            <article class="grid_wrap">
                <div id="sroCalendarGrid" style="width: 100%; height: 500px; margin: 0 auto;"></div>
            </article>
        </form>
    </section>
</section>


<script>

var now = new Date();
current = new Date(now.getMonth()+1);
console.log("fwtfweg")
console.log(current)

   const sroCalendarGrid = GridCommon.createAUIGrid("sroCalendarGrid",[
           {dataField : "genForeYyyy", headerText : "Year", editable: false},
           {dataField : "genForeMm",   headerText : "Month", editable: false},
           {dataField : "genForeBatch",   headerText : "Batch", editable: false},
           {dataField : "genBatchStartDt",   headerText : "Start Date",
        	 editable: true,
        	 dataType : "date",
             formatString : "yyyy/mm/dd",
             editRenderer : {
                 type : "CalendarRenderer",
                 showEditorBtnOver : true,
                 onlyCalendar : false,
                 showExtraDays : true
               }
           },
           {dataField : "genBatchRate",   headerText : "Rate", editable: true,
               dataType : "numeric",
               editRenderer : {
                   type : "InputEditRenderer",
                   showEditorBtnOver : true,
                   onlyNumeric : true,
                   allowPoint : false,
                   allowNegative : false,
                   textAlign : "right",
                   autoThousandSeparator : false
                 },
           },
           {dataField: "genTatYyyy", headerText: "Forecast Year", editable: false},
           {dataField: "genTatMm", headerText: "Forecast Month", editable: false}
     ],'',{
		   usePaging: true,
	       pageRowCount: 20,
	       headerHeight: 60,
	       showRowNumColumn: true,
	       wordWrap: true,
	       showStateColumn: false
     })

     document.getElementById('search').onclick = (event) => {
    	 event.preventDefault()
    	 Common.showLoader()
         let searchDt = $("#searchDt").val();
         if(searchDt!=""){
              $("#year").val(searchDt.substring(3));
              $("#month").val(searchDt.substring(0,2));
         }
    	 fetch("/logistics/stockReplenishment/selectWeeklyList.do?" + $("#searchForm").serialize())
    	 .then( r => r.json())
    	 .then( resp => {
    		 resp = resp.map( i => {
    			 return {
    				 ...i,
    				 genForeYyyy : i.genForeYyyy,
    				 genForeMm   : i.genForeMm,
    				 genForeBatch : i.genForeBatch,
    				 genBatchStartDt : i.genBatchStartDt,
    				 genBatchRate : i.genBatchRate,
    				 genTatYyyy : i.genTatYyyy,
    				 genTatMm : i.genTatMm
    			 }
    		 })
    		 Common.removeLoader()
    		 AUIGrid.setGridData(sroCalendarGrid, resp)
    	 })
     }

     document.getElementById('addRow').onclick = (event) => {
    	 event.preventDefault()

    	 let searchDt = $("#searchDt").val();
         let item = new Object();
         item.genForeYyyy = searchDt.substring(3);
         item.genForeMm = searchDt.substring(0,2);
         item.genForeBatch = "";
         item.genBatchStartDt = "";
         item.genBatchRate = "";
         item.genTatYyyy = item.genForeMm == 12 ? Number(item.genForeYyyy) + 1 : item.genForeYyyy;
         item.genTatMm = item.genForeMm == 12 ? "01" : String(Number(item.genForeMm) + 1).padStart(2,"0");

         let weekObj  = new Array();

         for(let i=0;i< AUIGrid.getGridData(sroCalendarGrid).length ;i++){
            weekObj[i]  = AUIGrid.getCellValue(sroCalendarGrid, i, 3);
            AUIGrid.setCellValue(sroCalendarGrid, i, "genForeMm", item.genForeMm);
            AUIGrid.setCellValue(sroCalendarGrid, i, "genForeYyyy", item.genForeYyyy);
            AUIGrid.setCellValue(sroCalendarGrid, i, "genTatMm", item.genTatMm);
            AUIGrid.setCellValue(sroCalendarGrid, i, "genTatYyyy", item.genTatYyyy);
         }

         if(weekObj.length >= 3){
             Common.alert("All Week has already been added.");
             return;
         }else{
             item.genForeBatch = "B" + String(AUIGrid.getGridData(sroCalendarGrid).length + 1);
         }
         AUIGrid.addRow(sroCalendarGrid, item, "last");
     }

     document.getElementById('save').onclick = (event) => {
    	 event.preventDefault()
    	 if(validationChange()){
    		 Common.showLoader()
    		 fetch("/logistics/stockReplenishment/saveSroCalendarGrid.do",
  				 {
	    			  method : "POST",
	    			  headers: {
	    				  "Content-Type" : "application/json",
	    			  },
	    			  body : JSON.stringify({data: AUIGrid.getGridData(sroCalendarGrid)}),
  				 })
  				 .then(r=> {return r.json()})
  				 .then(
  						 data => {
  							 Common.removeLoader()
  							 Common.alert(data.message,fn_reload);
  						 }
  				  )
    	 }
     }

     const validationChange = () => {
         let addList = AUIGrid.getAddedRowItems(sroCalendarGrid);
         let udtList = AUIGrid.getEditedRowItems(sroCalendarGrid);
         let allList = AUIGrid.getGridData(sroCalendarGrid);
         console.log(allList.length)

         if (addList.length == 0 && udtList.length == 0) {
             Common.alert("<spring:message code='sys.common.alert.noChange'/>");
             return false;
         }
         else if(allList.length != 3){
        	 Common.alert("Please configure completely for forecast month");
             return false;
         }
         else if(!validationDetails(allList)){
             return false;
         }
         return true;
     }

     const validationDetails = (list) => {
    	 let totalRate = 0;

         for (let i = 0; i < list.length; i++) {
        	    totalRate +=  list[i].genBatchRate;
        	    if (FormUtil.isEmpty(list[i].genBatchStartDt)) {
	                  Common.alert("Start Date cannot be empty value");
	                  return false;
                }
          }

    	 if(totalRate != 100){
	             Common.alert("Total of the Rate must equal to 100");
	             return false;
    	 }
         return true;
     }

     const fn_reload = () => {
    	 location.reload();
     }

</script>




