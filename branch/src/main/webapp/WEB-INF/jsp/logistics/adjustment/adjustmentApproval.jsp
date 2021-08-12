<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;
var myGridIDHide;
var myGridIDExcel;


var serialGrid;


var adjNo="${rAdjcode }";
//var adjLocation = "${rAdjlocId }";

var columnLayout=[
						{dataField: "invntryLocId",headerText :"<spring:message code='log.head.invntrylocid'/>" ,width:120 ,height:30, visible:false},                          
						{dataField: "invntryNo",headerText :"<spring:message code='log.head.stockauditno'/>"    ,width: "20%"    ,height:30},               
						{dataField: "docDt",headerText :"<spring:message code='log.head.docdate'/>" ,width: "20%"    ,height:30},               
						{dataField: "locId",headerText :"<spring:message code='log.head.locationid'/>"  ,width: "20%"    ,height:30},               
						{dataField: "locName",headerText :"<spring:message code='log.head.locationname'/>"  ,width: "20%"    ,height:30},               
						/*                   {dataField:    "serialPdChk",headerText :"<spring:message code='log.head.serialpdchk'/>"   ,width:120 ,height:30},                         
						{dataField: "serialFtChk",headerText :"<spring:message code='log.head.serialftchk'/>"   ,width:120 ,height:30},                         
						{dataField: "serialPtChk",headerText :"<spring:message code='log.head.serialptchk'/>"   ,width:120 ,height:30}, */                          
						{dataField: "saveYn",headerText :"<spring:message code='log.head.countstatus'/>"    ,width: "20%"    ,height:30}   
               ];          
var resop = {
		usePaging : false
		,editable:false
		};
$(document).ready(function(){
	searchHead();
     
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", resop);
//btn clickevent
$(function(){
    
    $('#list').click(function() {
        document.listForm.action = '/logistics/adjustment/NewAdjustmentRe.do';
        document.listForm.submit();
    });
    $('#approve').click(function() {
    	var status="A";
        fn_updateApproval(status);
    });
    $('#reject').click(function() {
    	var status="R";
    	fn_updateApproval(status);
    });
    $('#approve2').click(function() {
    	var status="A2";
        fn_updateApproval(status);
    });
    $('#reject2').click(function() {
    	var status="R2";
    	fn_updateApproval(status);
    });
    $('#complete').click(function() {
        var formData = new FormData();
        formData.append("excelFile", $("input[name=pdfUpload]")[0].files[0]);
        formData.append("adjNo", adjNo);

        Common.ajaxFile("/logistics/adjustment/pdfUpload.do", formData, function (result) {
            $("#auto_file").hide();
            $("#complete").hide();
        });
    });
     });
 });


function searchHead(){
    var param ="adjNo="+adjNo;
    var url = "/logistics/adjustment/oneAdjustmentNo.do";
    Common.ajax("GET" , url , param , function(result){
        var data = result.dataList;
        fn_setVal(data);
        searchGrid();
    });
}
 function searchGrid(){
    var param =
         {
    		invntryNo    : adjNo
        };
    var url = "/logistics/adjustment/adjustmentApprovalList.do";
    Common.ajax("GET" , url , param , function(result){
        var data = result.dataList;
        var data2 = result.cnt
        AUIGrid.setGridData(myGridID, data);
        fn_chck_approval(data2);        	
    });
}

 function  fn_chck_approval(data2){
	 
	 var total = data2[0].total;
	 var y =data2[0].y;
	 $('#checkYn').text(y+"/"+total);
	 
	 var param =
     {
        invntryNo    : adjNo
    }
var url = "/logistics/adjustment/adjustmentApprovalLineCheck.do";
Common.ajax("GET" , url , param , function(result){
   var data = result.dataList;
        $("#approve").hide();
        $("#reject").hide();
        $("#approve2").hide();
        $("#reject2").hide();
        $("#auto_file").hide();
        $("#complete").hide(); 
    if(data.length>0){
	    fn_approvalStatus(data);
   }
});
 }


	function fn_approvalStatus(data) {
	    
		if ("Y" == data[0].saveYn) {
			if (null == data[0].cnfm1 || "" == data[0].cnfm1) {
				$("#approve").show();
				$("#reject").show();
				$("#approve2").hide();
				$("#reject2").hide();
			} else if ("R" == data[0].cnfm1 || "R" == data[0].cnfm2) {
				$("#approve").hide();
				$("#reject").hide();
				$("#approve2").hide();
				$("#reject2").hide();
			} else if ("A" == data[0].cnfm1) {
				$("#approve").hide();
				$("#reject").hide();
				$("#approve2").show();
				$("#reject2").show();
			}

			if ("A" == data[0].cnfm1 & "A" == data[0].cnfm2) {
				$("#auto_file").show();
				$("#complete").show();
				$("#approve").hide();
				$("#reject").hide();
				$("#approve2").hide();
				$("#reject2").hide();
			} else {
				$("#auto_file").hide();
				$("#complete").hide();
				
			}

		} else {
			$("#approve").hide();
			$("#reject").hide();
			$("#approve2").hide();
			$("#reject2").hide();
			$("#auto_file").hide();
			$("#complete").hide();
			
		}
		
		if("C"==data[0].delFlag){
            $("#auto_file").hide();
            $("#complete").hide();
		}
        $("#lcdYn").text(data[0].cnfm1);
        $("#finYn").text(data[0].cnfm2);
}
	function fn_updateApproval(status) {

		var chckAuthority = "";// 권한 업데이트 함수 또는 팀으로 세팅 할 예정
		if (status == "A") {
		} else if (status == "R") {
		}

		var param = {
			invntryNo : adjNo,
			status : status
		};
		var url = "/logistics/adjustment/ApprovalUpdate.do";
		Common.ajax("GET", url, param, function(result) {
			var data = result.dataList;
			fn_approvalStatus(data);
		});

	}

	function fn_setVal(data) {
		//var status = "${rStatus }";
		$("#adjno").val(data[0].invntryNo);
		$("#bsadjdate").text(data[0].baseDt);
		$("#doctext").text(data[0].headTitle);
		var tmp = data[0].eventType.split(',');
		var tmp2 = data[0].itmType.split(',');
		var tmp3 = data[0].ctgryType.split(',');
		if (data[0].autoFlag == "A") {
			$("#auto").attr("checked", true);
		} else if (data[0].autoFlag == "M") {
			$("#manual").attr("checked", true);
		}
        fn_itemSet(tmp,"event");
        fn_itemSet(tmp2,"item");
        fn_itemSet(tmp3,"catagory");

	}

	function fn_itemSet(tmp, str) {
		var no;
        if(str=="event"){
            no=339;
        }else if(str=="item"){
            no=15;
        }else if(str=="catagory"){
            no=11;
        } 
		var url = "/logistics/adjustment/selectCodeList.do";
		$.ajax({
			type : "GET",
			url : url,
			data : {
				groupCode : no
			},
			dataType : "json",
			contentType : "application/json;charset=UTF-8",
			success : function(data) {
				fn_itemChck(data, tmp, str);
			},
			error : function(jqXHR, textStatus, errorThrown) {
			},
			complete : function() {
			}
		});
	}
	function fn_itemChck(data, tmp2, str) {
		var obj;
        if(str=="event" ){
            obj ="eventtypetd";
        }else if(str=="item"){
            obj ="itemtypetd";
        }else if(str=="catagory"){
            obj ="catagorytypetd";
        }
		obj = '#' + obj;

		$.each(data, function(index, value) {
			$('<label />', {
				id : data[index].code
			}).appendTo(obj);
			$('<input />', {
				type : 'checkbox',
				value : data[index].codeId,
				id : data[index].codeId
			}).appendTo('#' + data[index].code).attr("disabled", "disabled");
			$('<span />', {
				text : data[index].codeName
			}).appendTo('#' + data[index].code);
		});

		for (var i = 0; i < tmp2.length; i++) {
			$.each(data, function(index, value) {
				if (tmp2[i] == data[index].codeId) {
					$('#' + data[index].codeId).attr("checked", "true");
				}
			});
		}
	}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Approval -Stock Audit</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Approval -Stock Audit</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="list"><span class="list"></span>List</a></p></li>
  <!-- <li><p class="btn_blue"><a id="confirm"><span class="confirm"></span>Confirm</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="POST">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Stock Audit Number</th>
    <td><input id="adjno" name="adjno" type="text" title=""  class="w100p" readonly="readonly" /></td>
    <th scope="row">Auto/Manual</th>
    <td> 
         <label><input type="radio" name="auto" id="auto"    disabled="disabled" /><span>Auto</span></label>
         <label><input type="radio" name="manual" id="manual"   disabled="disabled" /><span>Manual</span></label>        
    </td>
</tr>
<tr>
    <th scope="row">Location Type</th>
     <td id="eventtypetd">
     </td>
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
</tr>
<tr>
        <th scope="row">Category Type</th>
        <td id="catagorytypetd">
    <th scope="row">Stock Audit Date</th>
    <td id="bsadjdate">
    </td>  
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan='3' id="doctext"><!-- <input type="text" name="doctext" id="doctext" class="w100p"  readonly="readonly"/> --></td>
    </tr>
    <tr>
    <th scope="row">Check Approval</th>
    <td id="checkYn">
    <td colspan="2"/>
    </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Location Info</h3>
</aside><!-- title_line end -->
<ul class="left_btns">

<%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
    <li><p class="btn_blue"><a id="approve"><span class="approve"></span>Approve</a></p></li>
  <li><p class="btn_blue"><a id="reject"><span class="reject"> </span>Reject</a></p></li>
    <li><p class="btn_blue"><a id="approve2"><span class="approve2"></span> Approve</a></p></li>
  <li><p class="btn_blue"><a id="reject2"><span class="reject2"></span> Reject</a></p></li>
  <li><p class="btn_blue"><div class="auto_file" id="auto_file"><!-- auto_file start -->
                                    <input type="file" id="fileSelector" name="pdfUpload" title="file add" accept=".pdf"/>
                                </div>
    </p></li>
  <li><p class="btn_blue"><a id="complete"><span class="complete"></span>Complete</a></p></li>
<%-- </c:if>   --%>
</ul>
<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" >

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:90px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr> 
    <th scope="row">LCD Team</th>
    <td id="lcdYn">
    </td>
    <th scope="row">Finance</th>
    <td id="finYn">
    </td>
    <th colspan="2" />
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

	<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
</article>
</section>
<form id="listForm" name="listForm" method="POST">
<input type="hidden" id="retnVal"    name="retnVal"    value="R"/>
</form>