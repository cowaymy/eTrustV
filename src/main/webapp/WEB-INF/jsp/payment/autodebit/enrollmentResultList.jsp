<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
var csvGridID;
var myGridID;
var viewGridID;
var newGridID;
var selectedGridValue;

var newDdGridID;

$(document).ready(function(){

	createAUIGrid();

	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	//viewGridID = GridCommon.createAUIGrid("grid_wrap_view", viewColumn,null,gridPros);
    newGridID = GridCommon.createAUIGrid("grid_wrap_new", newColumn,null,gridPros);

    newDdGridID = GridCommon.createAUIGrid("grid_wrap_dd_new", newColumnDD,null,gridPros);

    AUIGrid.setGridData(viewGridID, []);
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){
    	selectedGridValue = event.rowIndex;
    });

 // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
    function checkHTML5Brower() {
        var isCompatible = false;
        if (window.File && window.FileReader && window.FileList && window.Blob) {
            isCompatible = true;
        }
        return isCompatible;
    }

    // 파일 선택하기
    $('#fileSelector').on('change', function(evt) {
        if (!checkHTML5Brower()) {
            // 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
            // 파일 내용 읽어 반환시켜 그리드에 적용.
            commitFormSubmit();

            //alert("브라우저가 HTML5 를 지원하지 않습니다.");
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                return;
            }
            var reader = new FileReader();
            //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                    // 그리드 CSV 데이터 적용시킴
                    AUIGrid.setCsvGridData(newGridID, event.target.result, false);

                  //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(newGridID,0);
                } else {
                	Common.alert("<spring:message code='pay.alert.noData'/>");
                }
            };
            reader.onerror = function() {
            	Common.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
            };
        }
    });

    $('#fileSelector2').on('change', function(evt) {
        if (!checkHTML5Brower()) {
            // 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
            // 파일 내용 읽어 반환시켜 그리드에 적용.
            commitFormSubmit2();

            //alert("브라우저가 HTML5 를 지원하지 않습니다.");
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                return;
            }
            var reader = new FileReader();
            //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                    // 그리드 CSV 데이터 적용시킴
                    AUIGrid.setCsvGridData(newDdGridID, event.target.result, false);

                  //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(newDdGridID,0);
                } else {
                    Common.alert("<spring:message code='pay.alert.noData'/>");
                }
            };
            reader.onerror = function() {
                Common.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
            };
        }
    });

    doGetCombo('/payment/selectAutoDebitDeptUserId', 'C1002', '', 'userIdAutoDebitCode', 'S', '');

});

function createAUIGrid() {

    var columnLayout = [ {
          dataField : "appType",
      },{
          dataField : "payerNm",
      },{
          dataField : "payerId",
      },{
          dataField : "payerAccno",
      },{
          dataField : "payerPhoneno",
      },{
          dataField : "payerBankid",
      },{
          dataField : "payerEmail",
      },{
          dataField : "paymentPurpose",
      },{
          dataField : "maxAmt",
      },{
          dataField : "maxFreq",
      },{
          dataField : "freqMode",
      },{
          dataField : "effectiveDt",
      },{
          dataField : "expiryDt",
      },{
          dataField : "applyDt",
      },{
          dataField : "billerId",
      },{
          dataField : "payRef",
      },{
          dataField : "payerIdType",
      }
      ];

    var excelGridPros = {


    	      // 페이징 사용
    	      usePaging : true,

    	      // 한 화면에 출력되는 행 개수 20(기본값:20)
    	      pageRowCount : 20,

    	      editable : true,

    	      fixedColumnCount : 1,

    	      showStateColumn : false,

    	      displayTreeOpen : true,

    	      selectionMode : "multipleCells",

    	      headerHeight : 30,

    	      // 그룹핑 패널 사용
    	      useGroupingPanel : false,

    	      // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    	      skipReadonlyColumns : true,

    	      // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    	      wrapSelectionMove : true,

    	      // 줄번호 칼럼 렌더러 출력
    	      showRowNumColumn : true,

    	      showRowCheckColumn : true,

    	      groupingMessage : "Here groupping",

    	      showHeader: false
    };

    csvGridID = AUIGrid.create("#grid_wrap_hide", columnLayout, excelGridPros);
  }

//HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
//서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
//즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
function commitFormSubmit() {

AUIGrid.showAjaxLoader(newGridID);

// Submit 을 AJax 로 보내고 받음.
// ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
// 링크 : http://malsup.com/jquery/form/

$('#myForm').ajaxSubmit({
   type : "json",
   success : function(responseText, statusText) {
       if(responseText != "error") {

           var csvText = responseText;

           // 기본 개행은 \r\n 으로 구분합니다.
           // Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
           // 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
           // 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함.
           csvText = csvText.replace(/\r?\n/g, "\r\n")

           // 그리드 CSV 데이터 적용시킴
           AUIGrid.setCsvGridData(newGridID, csvText);

           AUIGrid.removeAjaxLoader(newGridID);

           //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
           AUIGrid.removeRow(newGridID,0);
       }
   },
   error : function(e) {
	   Common.alert("ajaxSubmit Error : " + e);
   }
});
}

function commitFormSubmit2() {

	AUIGrid.showAjaxLoader(newDdGridID);

	// Submit 을 AJax 로 보내고 받음.
	// ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
	// 링크 : http://malsup.com/jquery/form/

	$('#myDdForm').ajaxSubmit({
	   type : "json",
	   success : function(responseText, statusText) {
	       if(responseText != "error") {

	           var csvText = responseText;

	           // 기본 개행은 \r\n 으로 구분합니다.
	           // Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
	           // 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
	           // 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함.
	           csvText = csvText.replace(/\r?\n/g, "\r\n")

	           // 그리드 CSV 데이터 적용시킴
	           AUIGrid.setCsvGridData(newDdGridID, csvText);

	           AUIGrid.removeAjaxLoader(newDdGridID);

	           //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
	           AUIGrid.removeRow(newDdGridID,0);
	       }
	   },
	   error : function(e) {
	       Common.alert("ajaxSubmit Error : " + e);
	   }
	});
	}

var gridPros = {
        editable: false,
        showStateColumn: false,
        softRemoveRowMode:false
};

var columnLayout=[

    {dataField:"enrollupdateid", headerText:"<spring:message code='pay.head.updateBatchId'/>"},
    {dataField:"type", headerText:"<spring:message code='pay.head.updateType'/>"},
    {dataField:"totalupdate", headerText:"<spring:message code='pay.head.totalUpdate'/>"},
    {dataField:"totalsuccess", headerText:"<spring:message code='pay.head.totalSuccess'/>"},
    {dataField:"totalfail", headerText:"<spring:message code='pay.head.totalFail'/>"},
    {dataField:"createdate", headerText:"<spring:message code='pay.head.createDate'/>"},
    {dataField:"creator", headerText:"<spring:message code='pay.head.creator'/>"}
];

var viewColumn=[
     {dataField:"status", headerText:"<spring:message code='pay.head.status'/>"},
     {dataField:"orderno", headerText:"<spring:message code='pay.head.orderNo'/>"},
     {dataField:"inputday", headerText:"<spring:message code='pay.head.day'/>"},
     {dataField:"inputmonth", headerText:"<spring:message code='pay.head.month'/>"},
     {dataField:"inputyear", headerText:"<spring:message code='pay.head.year'/>"},
     {dataField:"inputrejectcode", headerText:"<spring:message code='pay.head.rejectCode'/>"},
     {dataField:"Message", headerText:"<spring:message code='pay.head.message'/>"}
];

var newColumn=[
      {dataField:"0", headerText:"<spring:message code='pay.head.orderNo'/>"},
      {dataField:"1", headerText:"<spring:message code='pay.head.month'/>"},
      {dataField:"2", headerText:"<spring:message code='pay.head.day'/>"},
      {dataField:"3", headerText:"<spring:message code='pay.head.year'/>"},
      {dataField:"4", headerText:"<spring:message code='pay.head.rejectCode'/>"}
];

var newColumnDD=[
               {dataField:"0", headerText:"PaymentID"},
               {dataField:"1", headerText:"Type"},
               {dataField:"2", headerText:"AccountNo"},
               {dataField:"3", headerText:"AccountType"},
               {dataField:"4", headerText:"AccountHolder"},
               {dataField:"5", headerText:"IssueBank"},
               {dataField:"6", headerText:"StartDate"},
               {dataField:"7", headerText:"RejectDate"},
               {dataField:"8", headerText:"RejectCode"},
               {dataField:"9", headerText:"Status"}
         ];
//리스트 조회.
function fn_getOrderListAjax() {
    Common.ajax("GET", "/payment/selectResultList", $("#resultForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
        selectedGridValue = undefined;
    });
}

showViewPopup = function() {
	if(selectedGridValue != undefined){
		$("#view_wrap").show();
		viewGridID = GridCommon.createAUIGrid("grid_wrap_view", viewColumn,null,gridPros);
		//viewGridID = GridCommon.createAUIGrid("grid_wrap_view", viewColumn,null,gridPros);
		var selectedId = AUIGrid.getCellValue(myGridID, selectedGridValue, "enrollupdateid");
		 Common.ajax("GET", "/payment/selectEnrollmentInfo", {"enrollId":selectedId}, function(result) {
		        console.log(result.info[0]);
		        $("#viewEnrollId").text(result.info[0].enrollupdateid);
		         $("#viewCreateDate").text(result.info[0].created);
		         $("#viewUpdateType").text(result.info[0].codename);
		         $("#viewCreator").text(result.info[0].creator);
		         $("#viewTotalUpdate").text(result.info[0].totalupdate);
		         $("#viewTotalSuccess").text(result.info[0].totalsuccess + "/" + result.info[0].totalfail);
		         AUIGrid.setGridData(viewGridID, result.item);
		         //AUIGrid.showAjaxLoader(viewGridID);
		 });
	}else{
        $("#view_wrap").hide();
        Common.alert("<spring:message code='pay.alert.noEnrollment'/>");
        return;
    }
}

hideViewPopup=function()
{
	$('#view_wrap').hide();
	AUIGrid.destroy("#grid_wrap_view");
}

showNewPopup = function() {
	$("#new_wrap").show();
}

hideNewPopup = function() {
	$("#new_wrap").hide();
	//$("#myForm").reset();
	//$("#fileSelector").replaceWith( $("#fileSelector").clone(true));
	$("#myForm").each(function(){
		this.reset();
	});
}

showDDNewPopup = function() {
	$("#new_dd_wrap").show();
}

hideDDNewPopup = function() {
    $("#new_dda_wrap").hide();
    $("#myDdaForm").each(function(){
        this.reset();
    });
}

showDDANewPopup  = function() {
    $("#new_dda_wrap").show();
}


hideDDANewPopup = function() {
    $("#new_dda_wrap").hide();
    $("#myDdaForm").each(function(){
        this.reset();
    });
}

//수정 처리
function fn_saveGridMap(type){

	//param data array
	var data = {};

	if (type =='DD'){ // eMandate

	    var gridList = AUIGrid.getGridData(newDdGridID);       //그리드 데이터
	    var formList = $("#myDdForm").serializeArray();       //폼 데이터

	    //array에 담기
	    if(gridList.length > 0) {
	        data.all = gridList;
	    }  else {
	    	Common.alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
	        return;
	        //data.all = [];
	    }

	    if(formList.length > 0){
	    	data.form = formList;
	    	data.type = ['DD'];
	    }
	    else data.form = [];

	} else {

        var gridList = AUIGrid.getGridData(newGridID);       //그리드 데이터
        var formList = $("#myForm").serializeArray();       //폼 데이터

        //array에 담기
        if(gridList.length > 0) {
            data.all = gridList;
        }  else {
            Common.alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
            return;
            //data.all = [];
        }

        if(formList.length > 0) {
        	data.form = formList;
        	data.type = [];
        }
        else data.form = [];
	}

    //Ajax 호출
    Common.ajax("POST", "/payment/uploadFile", data, function(result) {
        resetUpdatedItems(); // 초기화
        Common.alert(result.message);


    },  function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

//그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(myGridID, "a");
 }

function fn_clear(){
    $("#resultForm")[0].reset();
}

function fn_doPrint(){

    if($("#userIdAutoDebitCode").val() =="" || $("#userIdAutoDebitCode").val() == null){
           Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
           return ;
    }

    if($("#submitDt").val() =="" || $("#submitDt").val() == null){
        Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
        return ;
    }

     $("#V_USERID").val($("#userIdAutoDebitCode").val());
     $("#V_DATE").val($("#submitDt").val());

     var date = new Date();

     // Get the year, month, and day
     var year = date.getFullYear(); // Get the full year (e.g., 2024)
     var month = date.getMonth() + 1; // Get the month (0-indexed, so add 1)
     var day = date.getDate(); // Get the day of the month

     // Format the month and day to ensure they are always two digits (e.g., 01, 02, ..., 09)
     if (month < 10) {
         month = '0' + month; // Add leading zero to month if it's less than 10
     }
     if (day < 10) {
         day = '0' + day; // Add leading zero to day if it's less than 10
     }

     // Combine year, month, and day into a string formatted as YYYYMMDD
     var todayDate = year + '' + month + '' + day;

     Common.ajax("GET", "/payment/selectDdaCsv", $("#rptForm").serialize(),
    	      function(result) {
    	        AUIGrid.setGridData(csvGridID, result);

    	        Common.ajax("GET", "/payment/selectDdaCsvDailySeqCount", $("#rptForm").serialize(),
    	                function(result) {
    	                var count = result[0].docNo;
    	                var fileNm = "SE00070203" + todayDate + count;
    	                GridCommon.exportTo("grid_wrap_hide", "csv", fileNm);
    	       });
     });

     }

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Enrollment Result</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:fn_getOrderListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->


    <!-- search_table start -->
    <section class="search_table">
        <form name="resultForm" id="resultForm"  method="post">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:170px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Update Batch ID</th>
                        <td>
                            <input id="udtBatchId" name="udtBatchId" type="text" title="Update Batch ID" placeholder="Update Batch ID" class="w100p" />
                        </td>
                        <th scope="row">Creator</th>
                        <td>
                            <input id="creator" name="creator" type="text" title="Creator(Username)" placeholder="Creator(USername)" class="w100p" />
                        </td>
                        <th scope="row">Create Date</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                            <p><input type="text"  name="createDate1" id="createDate1" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text"  name="createDate2" id="createDate2" title="Create Date To" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Update Type</th>
                        <td colspan="5">
                            <select id="updateType" name="updateType" title="Update Type"  class="w100p" >
                                <option value="978">Submit Date</option>
                                <option value="979">Start Date</option>
                                <option value="980">Reject Date</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </section>

    <!-- search_result start -->
    <section class="search_result">

        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
           <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>

            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="#" onclick="javascript:showViewPopup()"><spring:message code='pay.btn.link.viewEnrollmentResult'/></a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showNewPopup()"><spring:message code='pay.btn.link.newEnrollmentResult'/></a></p></li>
                        <!-- Added for E-mandate paperless, Hui Ding 11/09/2023 -->
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showDDNewPopup()"><spring:message code='pay.btn.link.newDDEnrollmentResult'/></a></p></li>
                         <!-- Added for DDA, Keat Ye 26/12/2024 -->
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showDDANewPopup()"><spring:message code='pay.btn.link.newDDAFile'/></a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
            </c:if>

        </aside>
        <!-- link_btns_wrap end -->

        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap mt10"></article>
        <!-- grid_wrap end -->
    </section>
</section>

<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1>Enrollment Update Info</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup()"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <!-- table start -->
        <table class="type1">
            <caption>table</caption>
            <colgroup>
                <col style="width:165px" />
                <col style="width:*" />
                <col style="width:165px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Update Batch ID</th>
                    <td id="viewEnrollId"></td>
                    <th scope="row">Create Date</th>
                    <td id="viewCreateDate"></td>
                </tr>
                <tr>
                    <th scope="row">Update Type</th>
                    <td id="viewUpdateType"></td>
                    <th scope="row">Creator</th>
                    <td id="viewCreator"></td>
                </tr>
                <tr>
                    <th scope="row">Total Update</th>
                    <td id="viewTotalUpdate"></td>
                    <th scope="row">Total Success / Fail</th>
                    <td id="viewTotalSuccess"></td>
                </tr>
            </tbody>
        </table>

        <!-- grid_wrap start -->
        <article id="grid_wrap_view" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
</div>
<!-- popup_wrap end -->

<div id="new_wrap" class="popup_wrap" style="display:none;">
    <header class="pop_header">
        <h1>Enrollment Result Update</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideNewPopup()"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>

    <!-- pop_body start -->
    <section class="pop_body">
        <!-- search_table start -->
        <ul class="right_btns mb10">
            <li><p class="btn_blue"><a href="javascript:fn_saveGridMap();"><spring:message code='sys.btn.save'/></a></p></li>
            <li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/payment/EnrollmentResult_Format.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
        </ul>
        <section class="search_table">
            <form name="myForm" id="myForm">
                <!-- table start -->
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:175px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Update Type</th>
                            <td>
                                <select name="updateType" id="updateType"  style="width:100%">
                                    <option value="978">Submit Date</option>
                                    <option value="979">Start Date</option>
                                    <option value="980">Reject Date</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Select your CSV file *</th>
                            <td>
                                <div class="auto_file"><!-- auto_file start -->
                                    <input type="file" id="fileSelector" title="file add" accept=".csv"/>
                                </div><!-- auto_file end -->
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </section>

        <!-- grid_wrap start -->
            <article id="grid_wrap_new" class="grid_wrap" style="display:none;"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- pop_body end -->
</div>


<div id="new_dd_wrap" class="popup_wrap" style="display:none;">
    <header class="pop_header">
        <h1>New DD Paperless  Enrollment Result Update</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDDNewPopup()"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>

    <!-- pop_body start -->
    <section class="pop_body">
        <!-- search_table start -->
        <ul class="right_btns mb10">
            <li><p class="btn_blue"><a href="javascript:fn_saveGridMap('DD');"><spring:message code='sys.btn.save'/></a></p></li>
            <li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/payment/DD_EnrollmentResult_Format.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
        </ul>
        <section class="search_table">
            <form name="myDdForm" id="myDdForm">
                <!-- table start -->
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:175px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Update Type</th>
                            <td>
                                <select name="updateType" id="updateType"  style="width:100%">
                                    <!-- <option value="978">Submit Date</option> -->
                                    <option value="979">Start Date</option>
                                    <!-- <option value="980">Reject Date</option> --> <!--  Removed as currently not using. Hui Ding, 11/03/2024 -->
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Select your CSV file *</th>
                            <td>
                                <div class="auto_file"><!-- auto_file start -->
                                    <input type="file" id="fileSelector2" title="file add" accept=".csv"/>
                                </div><!-- auto_file end -->
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </section>

        <!-- grid_wrap start -->
            <article id="grid_wrap_dd_new" class="grid_wrap" style="display:none;"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- pop_body end -->
</div>

<div id="new_dda_wrap" class="popup_wrap" style="display:none;">
    <header class="pop_header">
        <h1>NEW CORPORATE DDA FILE</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideDDANewPopup()"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>

    <!-- pop_body start -->
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <form name="myDdaForm" id="myDdaForm">
                <!-- table start -->
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:175px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">User ID</th>
                            <td>
                                <select id="userIdAutoDebitCode" name="userIdAutoDebitCode" class="w100p"></select>
                            </td>
                            <th scope="row">Submit Date</th>
                            <td>
                             <div class="date_set w100p">
                              <!-- date_set start -->
                              <p>
                               <input type="text" title="Create start Date" value=""
                                placeholder="DD/MM/YYYY" class="j_date w100p" id="submitDt"
                                name="submitDt" />
                              </p>
                             </div>
                             <!-- date_set end -->
                            </td>
                        </tr>


                    </tbody>
                </table>
                <ul class="center_btns">
                    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_doPrint()"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
                </ul>
            </form>

            <form id="rptForm">
              <input type="hidden" id="reportFileName" name="reportFileName" />
              <input type="hidden" id="viewType" name="viewType" value="CSV" />
              <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
              <input type="hidden" id="V_USERID" name="V_USERID" />
              <input type="hidden" id="V_DATE" name="V_DATE" />
          </form
        </section>

         <section class="search_result">
          <!-- search_result start -->
             <article class="grid_wrap_hide">
             <!-- grid_wrap start -->
             <div id="grid_wrap_hide"
              style="width: 100%; height: 480px; margin: 0 auto; display: none;"></div>
            </article>
          <!-- grid_wrap end -->
         </section>
    </section>
    <!-- pop_body end -->
</div>

