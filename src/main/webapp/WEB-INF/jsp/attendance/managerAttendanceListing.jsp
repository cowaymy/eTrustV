<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
    .hidden {
        display: none;
    }
</style>

<script type="text/javaScript">

  var nowYear = new Date().getFullYear();
  var monthOptions = {//년월달력 세팅
	    pattern: 'mm/yyyy',
	    selectedYear: nowYear,
	    selectedMonth: '10',
	    startYear: 2022,
	    finalYear: 2027,
	    disabledMonths: nowYear == 2022 ? [1,2,3,4,5,6,7,8,9] : []
  };

 function setMonthPicker(monthOptions) {
	    $('.j_date2').monthpicker(monthOptions).bind('monthpicker-change-year', (e, year) => {
	        if (year == 2022) {
	            $(e.target).monthpicker('disableMonths', [1,2,3,4,5,6,7,8,9]);
	        } else {
	            $(e.target).monthpicker('disableMonths', []);
	        }
	    })
  }

  $(document).on("focus", ".j_date2", function(){
	      setMonthPicker(monthOptions);
  });

  var option = {
    width : "1200px",
    height : "500px"
  };

  var ItmOption = {
	        type : "S",
	        isCheckAll : false
   };

  var myAtdGridID;
  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false,
  };

  const changeRank = () =>{
      switch($("#rank").val()) {
        case "6988":
            CommonCombo.make('managerCode', "/attendance/selectManagerCode.do", {memLvl : 1} , '${deptCode}', ItmOption, callback);
         break;

        case "6989":
            CommonCombo.make('managerCode', "/attendance/selectManagerCode.do", {memLvl : 2} , '${deptCode}', ItmOption, callback);
            break;

        case "6990":
            CommonCombo.make('managerCode', "/attendance/selectManagerCode.do", {memLvl : 3} , '${deptCode}', ItmOption, callback);
            break;
      }
}

  const changeCode = () => {
	  document.querySelector("#managerCodeHeader").innerText = "";
	  document.querySelector("#managerCodeDetails").innerHTML = "";
	  if ($("#rank").val() == "6991" || "${memLvl}" == "4") {
		  document.querySelector("#managerCodeHeader").innerText = "HP Code";
		  document.querySelector("#managerCodeDetails").innerHTML = `<input class="w100p" type="text" name="hpCode" id="hpCode"/>`;
		  if("${memLvl}" == "4"){
			 $("#hpCode").val("${SESSION_INFO.userName}");
             $("#hpCode").attr("readonly", "readonly");
             document.querySelector("#hpCode").style.background = "#ede9e9";
		   }
	  }else{
		  document.querySelector("#managerCodeHeader").innerText = "Manager Code";
		  document.querySelector("#managerCodeDetails").innerHTML = `<select class="w100p" id="managerCode" name="managerCode"></select>`;
		  changeRank();
	  }
  }



  const callback = () => {
        if ("${deptCode}") {
         $("#rank").val(${memLvl} == 1 ? '6988' : ${memLvl} == 2 ? '6989' : ${memLvl} == 3 ? '6990' : '6991')
            $('#rank :not(:selected)').prop('disabled', 'disabled')
            $('#managerCode :not(:selected)').prop('disabled', 'disabled')
        }
   }

  $(function() {
  	     $("#rank").change(function(){
  	            changeCode();
  	     });
  });


  $(document).ready(function() {
	    let rankParam = {groupCode : 527, codeIn :[6988,6989,6990,6991]};
	    CommonCombo.make('rank', "/sales/pos/selectPosModuleCodeList", rankParam , '', ItmOption, callback);
        atdManagementGrid();
        callback();
        changeCode();
   });

  function atdManagementGrid() {
    var columnLayout = [
        {
          dataField : "atdDate",
          headerText : "Date",
          editable : false,
          width : 150
        },
        {
          dataField : "atdDay",
          headerText : "Day",
          editable : false,
          width : 150
        },
        {
          dataField : "time",
          headerText : "QR - A0001",
          width : 200
        },
        {
          dataField : "eLeave",
          headerText : "Public Holiday - A0002",
          width : 200
        },
        {
          dataField : "publicHoliday",
          headerText : "State Holiday - A0003",
          width : 200
        },
        {
          dataField : "training",
          headerText : "RFA - A0004",
          editable : false,
          width : 200
        },
        {
            dataField : "attendance",
            headerText : "Waived - A0005",
            editable : false,
            width : 150
          }
    ];

    var gridPros = {
      //showRowCheckColumn : true,
      usePaging : true,
      pageRowCount : 20,
      //showRowAllCheckBox : true,
      editable : false,
      selectionMode : "multipleCells"
    };

    myAtdGridID = AUIGrid.create("#grid_wrap_atdList", columnLayout, gridPros);
  }

  function fn_searchAtdManagement() {
        if(fn_chkItemVal()){
            Common.ajax("GET", "/attendance/searchAtdManagementList.do", $("#AtdForm").serialize(), function(result) {
                AUIGrid.setGridData(myAtdGridID, result);
            });
        }
  }

  function fn_chkItemVal(){

        if($("#rank").val() == "6991" || "${memLvl}" == "4"){
            if(FormUtil.isEmpty($('#hpCode').val())) {
                Common.alert("Please key in HP Code");
                return false;
             }

            if(FormUtil.isEmpty($('#calMonthYear').val())) {
                Common.alert("Please choose the Month");
                return false;
             }
        }else{
            if(FormUtil.isEmpty($('#rank').val())) {
                Common.alert("Please choose the Rank.");
                return false;
             }

            if(FormUtil.isEmpty($('#managerCode').val())) {
                Common.alert("Please choose the Manager Code.");
                return false;
             }

            if(FormUtil.isEmpty($('#calMonthYear').val())) {
                Common.alert("Please choose the Month");
                return false;
             }
        }
        return true;
	}



  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
//     GridCommon.exportTo("grid_wrap_atdList", "xlsx", "Manager Attendance Listing");
	  Common.popupDiv("/attendance/attendanceExcelPop.do", null, null, true, '');
  }


  /*KV*/
  function fn_aoAsDataListing() {
      Common.popupDiv("/services/as/report/aoAsDataListingPop.do", null, null, true, '');
      }

  function f_multiCombo() {
    $(function() {
        $('#cmbbranchId').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        });

        $('#cmbInsBranchId').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        });

    });
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
              if($("#memType").val() != "7"){
                   this.selectedIndex = 0;
              }
          }

      });
  };

   function fn_asRawData(ind) {
        Common.popupDiv("/attendance/downloadManagerYearlyAttendance.do", {ind: ind}, null, true, '');
   }

   const toggleReset = () => {
	    clearGrid()
	    document.querySelector(".deviceResetPop")?.classList.toggle("hidden")
   }

   const resetAttendToken = () => {
	   const attendMemCode = $("#attendMemCode").val().trim()
	   if (attendMemCode) {
		   Common.confirm("Are you sure to reset this attendance device? HP: " + attendMemCode, () => {
			   Common.showLoader()
			   fetch("/attendance/resetAttendance.do", {
	               method: "POST",
	               headers: {"Content-Type": "application/json"},
	               body: JSON.stringify({memCode: attendMemCode})
	           })
	           .then(r => r.json())
	           .then(d => {
	        	    Common.alert(d.message)
	           })
	           .finally(() => {
	        	   Common.removeLoader()
	           })
		   })
	   }
   }

   const getHist = () => {
	   const attendMemCode = $("#attendMemCode").val().trim()
       if (attendMemCode) {
           Common.showLoader()
           fetch("/attendance/getAttendanceResetHist.do?memCode=" + attendMemCode)
           .then(r => r.json())
           .then(d => {
        	   if (d.success) {
	        	   clearGrid()
	        	   AUIGrid.create("#tokenResetList", [
	        	       {dataField: "upd_user", headerText: "Upd By"},
	        	       {dataField: "dt", headerText: "Date"}
	        	   ], {
	        		   editable: false,
	        		   usePaging: true
	        	   })
	        	   AUIGrid.setGridData("#tokenResetList", d.data.dataList.map(d => {
	        		   return {...d, dt: moment(d.dt.replace("Z", "")).format("YYYY/MM/DD HH:mm:ss")}
	        	   }))
        	   } else {
        		   Common.alert(d.message)
        	   }
           })
           .finally(() => {
               Common.removeLoader()
           })
       }
   }

   const clearGrid = () => {
	   document.querySelector("#tokenResetList").innerHTML = ""
   }


</script>
<section id="content">
 <!-- content start -->
 <ul class="path"></ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>Manager Attendance Listing</h2>
  <form action="#" id="inHOForm">
   <div style="display: none">
    <input type="text" id="in_asId" name="in_asId" />
    <input type="text" id="in_asNo" name="in_asNo" />
    <input type="text" id="in_ordId" name="in_ordId" />
    <input type="text" id="in_asResultId" name="in_asResultId" />
    <input type="text" id="in_asResultNo" name="in_asResultNo" />
    <input type="text" id="dt_range" name="dt_range" value="${DT_RANGE}" />
   </div>
  </form>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onClick="fn_searchAtdManagement()"><span class="search"></span><spring:message code='sys.btn.search'/></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a href="#" onclick="javascript:$('#AtdForm').clearForm();"><span class="clear"></span><spring:message code='service.btn.Clear'/></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form action="#" method="post" id="AtdForm">
   <table class="type1">
    <!-- table start -->
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
     <th scope="row">Rank</th>
     <td colspan="3">
	     <select class="w100p" id="rank" name="rank">
		     <option value="">Choose One</option>
		     <option value="6988">GM</option>
		     <option value="6989">SM</option>
		     <option value="6990">HM</option>
		     <option value="6991">HP</option>
	     </select>
     </td>

      <th scope="row" id="managerCodeHeader"></th>
      <td colspan='3' id="managerCodeDetails"></td>

     </tr>
     <tr>

      <th scope="row">Month</th>
      <td colspan='3'><input type="text" id="calMonthYear" name="calMonthYear" title="Month" class="j_date2 w100p" placeholder="Choose one" /></td>

	  <th></th>
	  <td colspan='3'></td>

     </tr>



    </tbody>
   </table>
   <!-- table end -->
   <aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt><spring:message code='sales.Link'/></dt>
     <dd>
      <ul class="btns">
      </ul>
      <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine11 == 'Y'}">
         <li>
          <p class="link_btn type2">
           <a href="#" onclick="fn_asRawData(1)">Download Manager Yearly Attendance</a>
          </p>
         </li>
        </c:if><c:if test="${PAGE_AUTH.funcUserDefine12 == 'Y'}">
         <li>
          <p class="link_btn type2">
           <a href="#" onclick="toggleReset()">Reset Attendance Device</a>
          </p>
         </li>
        </c:if>
      </ul>
      <p class="hide_btn">
       <a href="#"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
    </dl>
   </aside>
   <!-- link_btns_wrap end -->
   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
      </p></li>
    </c:if>
   </ul>
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_atdList"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
</section>
<!-- content end -->

<div class="popup_wrap size_mid deviceResetPop hidden"><!-- popup_wrap start -->
    <header class="pop_header">
        <h1>Reset Attendance Device</h1>
	    <ul class="right_opt">
	        <li><p class="btn_blue2"><a href="#" onclick="toggleReset()">Close</a></p></li>
	    </ul>
    </header>
    <section class="pop_body"><!-- pop_body start -->
        <table class="type1">
            <colgroup>
                <col style="width: 130px;"/>
                <col style="width: *;"/>
            </colgroup>
            <tbody>
                <tr>
                    <th>Mem Code</th>
                    <td><input type="text" id="attendMemCode"/></td>
                </tr>
            </tbody>
        </table>
        <ul class="center_btns">
            <li><p class="btn_blue2 big">
                <a href="#" onclick="resetAttendToken()">Reset</a>
            </p></li>
            <li><p class="btn_blue2 big">
                <a href="#" onclick="getHist()">Search History</a>
            </p></li>
        </ul>
        <div id="tokenResetList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    </section>
</div>