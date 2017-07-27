<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;
var viewGridID;
var newGridID;
var selectedGridValue; 

$(document).ready(function(){
	
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	//viewGridID = GridCommon.createAUIGrid("grid_wrap_view", viewColumn,null,gridPros);
    newGridID = GridCommon.createAUIGrid("grid_wrap_new", newColumn,null,gridPros);
    
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
                } else {
                    alert('No data to import!');
                }
            };
            reader.onerror = function() {
                alert('Unable to read ' + file.fileName);
            };
        }
    });
    
    
});

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
       }
   },
   error : function(e) {
       alert("ajaxSubmit Error : " + e);
   }
});
}

var gridPros = {
        editable: false,
        showStateColumn: false
};

var columnLayout=[
                      
    {dataField:"enrollupdateid", headerText:"Update Batch ID"},
    {dataField:"type", headerText:"Update Type"},
    {dataField:"totalupdate", headerText:"Total Update"},
    {dataField:"totalsuccess", headerText:"Total Success"},
    {dataField:"totalfail", headerText:"Total Fail"},
    {dataField:"createdate", headerText:"Create Date"},
    {dataField:"creator", headerText:"Creator"}
];

var viewColumn=[
     {dataField:"status", headerText:"Status"},    
     {dataField:"orderno", headerText:"Order No"},   
     {dataField:"inputday", headerText:"Day"},   
     {dataField:"inputmonth", headerText:"Month"},   
     {dataField:"inputyear", headerText:"Year"},   
     {dataField:"inputrejectcode", headerText:"Reject Code"},   
     {dataField:"Message", headerText:"Message"}
];

var newColumn=[
      {dataField:"0", headerText:"OrderNo"},
      {dataField:"1", headerText:"Month"},
      {dataField:"2", headerText:"Day"},
      {dataField:"3", headerText:"Year"},
      {dataField:"4", headerText:"RejectCode"}
];
//리스트 조회.
function fn_getOrderListAjax() {        
    Common.ajax("GET", "/payment/selectResultList", $("#resultForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
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

//수정 처리
function fn_saveGridMap(){
    
    //param data array
    var data = {};

    var gridList = AUIGrid.getGridData(newGridID);       //그리드 데이터
    var formList = $("#myForm").serializeArray();       //폼 데이터
    
    //array에 담기        
    if(gridList.length > 0) {
        data.all = gridList;
    }  else {
    	Common.alert('Select the CSV file on the loca PC');
        return;
        //data.all = [];
    }
    
    if(formList.length > 0) data.form = formList;
    else data.form = [];
    
    //Ajax 호출
    Common.ajax("POST", "/payment/uploadFile", data, function(result) {
        Common.setMsg(result.message);  
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
        alert("Fail : " + jqXHR.responseJSON.message);        
    });
}

//그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(myGridID, "a");
 }
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Auto Debit</li>
        <li>Enrollment Result</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Enrollment Result</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getOrderListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="resultForm" id="resultForm"  method="post">

            <table class="type1"><!-- table start -->
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
                           <div class="date_set"><!-- date_set start -->
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
            <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <!-- <li><p class="link_btn"><a href="#">menu1</a></p></li> -->
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showViewPopup()">View Enrollment Result</a></p></li>
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showNewPopup()">New Enrollment Result</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section>
</section>

<div class="popup_wrap" id="view_wrap" style="display:none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Enrollment Update Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

    <table class="type1"><!-- table start -->
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
</div><!-- popup_wrap end -->

<div id="new_wrap" class="popup_wrap" style="display:none;">
    <header class="pop_header">
        <h1>Enrollment Result Update</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideNewPopup()">CLOSE</a></p></li>
        </ul>
    </header>
    
    <section class="pop_body"><!-- pop_body start -->
    
    <form name="myForm" id="myForm">
    <table class="type1"><!-- table start -->
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
          <center><a href="javascript:fn_saveGridMap();"><img src="../resources/images/common/btn.gif" alt="Read CSV" /></a>
          <a href="#" class="search_btn"><img src="../resources/images/common/btn.gif" alt="Download CSV Format" /></a></center>
    </form>
    <!-- grid_wrap start -->
    <article id="grid_wrap_new" class="grid_wrap" style="display:none;"></article>
    <!-- grid_wrap end -->
</section><!-- pop_body end -->
</div>
