<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_order;
var myGridID_remark;
var complianceList;
var file1ID = 0;
var file1Name = "";
$(document).ready(function(){

    fn_GuardianRemarkGrid();
    fn_guardianRemark();

	doGetComboAndGroup2('/organization/compliance/getPicList.do', {}, '', 'changePerson', 'S', 'fn_setOptGrpClass');//product 생성

    var reqstCtgry = "${guardianofCompliance.reqstCtgry}";
    $("#caseCategory option[value='"+ reqstCtgry +"']").attr("selected", true);

    var reqstCtgrySub = "${guardianofCompliance.reqstCtgrySub}";
    $("#docType option[value='"+ reqstCtgrySub +"']").attr("selected", true);

    var reqstStus = "${guardianofCompliance.reqstStusId}";

    if(reqstStus == 5 || reqstStus == 6){
        $('#empty').addClass("blind");
        $('#status').addClass("blind");
        $('#save').addClass("blind");
        $('#ccontent').addClass("blind");

    } else {
        $('#empty').removeClass("blind");
        $('#status').removeClass("blind");
        $('#ccontent').removeClass("blind");

        if(reqstStus == 10 || reqstStus == 36) {
            $('#save').addClass("blind");
            $("#cmbreqStatus").attr("readonly", "readonly");
        } else {
            $('#save').removeClass("blind");
        }
    }

    console.log("Person In Charge :: " + "${guardianofCompliance.personInChrg}");
    $("#changePerson option[value='" + "${guardianofCompliance.personInChrg}" +"']").attr("selected", true);

    $("#cmbreqStatus option[value='" + "${guardianofCompliance.reqstStusId}" + "']").attr('selected', true);
});

function fn_GuardianRemarkGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "name",
        headerText : "Status",
        editable : false,
        width : 80
    }, {
        dataField : "respnsMsg",
        headerText : "Remark",
        editable : false,
        width : 550
    }, {
        dataField : "userName",
        headerText : "Respond By",
        editable : false,
        width : 130
    }, {
        dataField : "respnsCreated",
        headerText : "Respond At",
        editable : false,
        width : 130
    },{
        dataField : "",
        headerText : "Attachment",
        width : 130,
        renderer : {
            type : "ButtonRenderer",
            labelText : "Download",
            onclick : function(rowIndex, columnIndex, value, item) {
              console.log(item.fileId);
              console.log(item);
              fileDown(rowIndex);
              //$('.aui-grid-button-renderer').hide();
            }
        }
        , editable : false
    }];
     // 그리드 속성 설정
    var gridPros = {

             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
             editable            : false,

             showStateColumn     : false,
             displayTreeOpen     : false,
             selectionMode       : "singleRow",  //"multipleCells",
             headerHeight        : 30,
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
          // 워드랩 적용
             wordWrap : true
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_remark = AUIGrid.create("#grid_wrap_remark", columnLayout, gridPros);

}

function fn_removeDownload(res) {
	$("#grid_wrap_remark tr.aui-grid-row-background, #grid_wrap_remark tr.aui-grid-alternative-row-background").each(function(i, item) {
        if (i < res.length && !res[i].fileId) {
            $(item).find('td:last-child div').remove();
        }
    });
}

function fn_guardianRemark(){
    Common.ajax("GET", "/organization/compliance/guardianRemark.do", {reqstId : "${guardianofCompliance.reqstId }"}, function(result) {
        console.log("성공.");
        AUIGrid.setGridData(myGridID_remark, result);
        fn_removeDownload(result);
        AUIGrid.bind(myGridID_remark, 'sorting', function() {
            AUIGrid.refresh(myGridID_remark);
            const download = AUIGrid.getGridData(myGridID_remark);
            fn_removeDownload(download);
        })
    });
}

function fn_caseChange (val) {

    if(val == '2144' ){
        $("select[name=docType]").removeAttr("disabled");
        $("select[name=docType]").removeClass("w100p disabled");
        $("select[name=docType]").addClass("w100p");
     }else{
          $("#docType").val("");
          $("select[name=docType]").attr('disabled', 'disabled');
          $("select[name=docType]").addClass("disabled");
          //$("select[name=docType]").addClass("w100p");
     }

}

function fn_validation(){
    if($("#caseCategory").val() == "" ){
            Common.alert("Please select a case category");
            return false;
    }
    if($("#caseCategory").val() == "2144"){
        if($("#docType").val() == ""){
            Common.alert("Please select a case detail");
            return false;
        }
    }
    if($("#cmbreqStatus").val() == ""){
            Common.alert("Please select a status");
            return false;
    }

   /*  if($("#changePerson").val() == ""){
        Common.alert("Please select a person in charge");
        return false;
    } */

    if($("#cmbreqStatus").val() == "60" || $("#cmbreqStatus").val() == "10"){
        if($("#complianceContent").val() == ""){
            Common.alert("Remark field is empty");
            return false;
        }
    }
    return true;
}

function fn_save(){
    if(fn_validation()){
    	var formData = Common.getFormData("saveForm");
    	var obj = $("#saveForm").serializeJSON();
	    $.each(obj, function(key, value) {
	        formData.append(key, value);
	      });

        Common.ajaxFile("/organization/compliance/saveGuardianCompliance2.do",formData , function(result) {
            console.log("성공.");
            Common.alert("Compliance call Log saved.<br /> Case No : "+result.data+"<br />", fn_guardianViewPopClose());
        });
        /*
    	if($("#cmbreqStatus").val() == '36'){
    		Common.ajax("POST", "/organization/compliance/saveGuardianCompliance2.do",$("#saveForm").serializeJSON() , function(result) {
                console.log("성공.");
                Common.alert("Compliance call Log saved.<br /> Case No : "+result.data+"<br />", fn_guardianViewPopClose());
    	});
    	}
    	else{
    		Common.ajax("POST", "/organization/compliance/saveGuardianCompliance.do",$("#saveForm").serializeJSON() , function(result) {
                console.log("성공.");
                if(result.data){
                    Common.alert("Compliance call Log saved.<br />", fn_guardianViewPopClose());
                }else{
                    Common.alert("Compliance call Log saved Fail.<br />");
                }
            });
    	}
        */
    }
    fn_complianceSearch();
}

function fn_guardianViewPopClose() {

    $('#btnGuarViewClose').click();
}

function fn_memberListNew(){

	Common.ajax("GET", "/organization/compliance/guardianAttachDownload.do", {cmplncAtchFileGrpId : "${guardianofCompliance.reqstAtchFileGrpId}"}, function(result) {
	    console.log("성공.");

	    if( result == null ){
	        Common.alert("File is not exist.");
	        return false;
	    }
	    var fileSubPath = result.fileSubPath;
	    var physiclFileName = result.physiclFileName;
	    var atchFileName = result.atchFileName
	    fileSubPath = fileSubPath.replace('\', '/'');
	    console.log("/file/fileDown.do?subPath=" + fileSubPath
	            + "&fileName=" + physiclFileName + "&orignlFileNm=" + atchFileName);
	    window.open("/file/fileDown.do?subPath=" + fileSubPath
	        + "&fileName=" + physiclFileName + "&orignlFileNm=" + atchFileName)
	});
}

function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text")
}

$("#file1Txt").dblclick(function(){
	var data = {
	        reqstId : '${guardianofCompliance.reqstId}'
	};
	Common.ajax("GET", "/organization/compliance/getAttachmentInfo.do", data, function(result) {
	   if(result != null){
	       var fileSubPath = result.fileSubPath;
	       fileSubPath = fileSubPath.replace('\', '/'');
	       window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
	   }
	});
});

function fileDown(rowIndex){

    var gridObj = AUIGrid.getSelectedItems(myGridID_remark);
    var reqst_id = gridObj[0].item.paparazReqstId;
    var atchFileGrpId = gridObj[0].item.atchFileGrpId;
    var atchFileId = gridObj[0].item.atchFileId;
	var data = {
			   reqstId : reqst_id,
			   atchFileGrpId : atchFileGrpId,
			   atchFileId : atchFileId
	};

	Common.ajax("GET", "/organization/compliance/getAttachmentInfo.do", data, function(result) {
		if(result != null){
		         var fileSubPath = result.fileSubPath;
		         fileSubPath = fileSubPath.replace('\', '/'');
		         window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
		}
	});
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Guardian of Coway View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="btnGuarViewClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case No</th>
    <td>
    <span>${guardianofCompliance.reqstNo }</span>
    </td>

</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="tap_wrap" id="tabDetail"><!-- tap_wrap start -->
<ul class="tap_type1">

    <li><a href="#" class="on">Request Details</a></li>
    <li><a href="#" onclick="javascirpt:AUIGrid.resize(myGridID_remark, 950,300);">Response</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<form action="#" method="post" id="saveForm">
<input type="hidden" title="" placeholder="" class="" id="hidRequestId" name=reqstId value="${guardianofCompliance.reqstId}"/>
<input type="hidden" title="" placeholder="" class="" id="hidMemberId" name=memId value="${guardianofCompliance.reqstMemId}"/>
<input type="hidden" title="" placeholder="" class="" id="hidOrderId" name=orderId value="${guardianofCompliance.reqstOrdId}"/>
<input type="hidden" title="" placeholder="" class="" id="hidActionId" name=actionId value="${guardianofCompliance.reqstActnId}"/>
<input type="hidden" title="" placeholder="" class="" id="hidFileName" name=hidFileName value="${guardianofCompliance.reqstAttach}"/>
<input type="hidden" title="" placeholder="" class="" id="hidGroupID" name=groupId value="${guardianofCompliance.reqstAtchFileGrpId}"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />

</colgroup>
<tbody>
<tr>
    <th scope="row">Request Status</th>
    <td colspan="3">
    <input type="text" title=""  name="reqStatus" id="reqStatus" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.name}"/>
    </td>
    <th scope="row">Customer Complaint Date</th>
    <td colspan="3">
    <input type="text" title=""  name="custCplntDt" id="custCplntDt" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.reqstRefDt}"/>
    </td>

</tr>
<tr>
    <th scope="row">Order No</th>
    <td colspan="3">
    <input type="text" title=""  name="orderNo" id="orderNo" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.salesOrdNo}"/>
    </td>
    <th scope="row">Customer Name</th>
    <td colspan="3">
    <input type="text" title=""  name="customerName" id="customerName" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.custName}"/>
    </td>
</tr>
<tr>
    <th scope="row">Customer Contact</th>
    <td colspan="3">
    <input type="text" title=""  name="custContact" id=""custContact"" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.telM1}"/>
    </td>
    <th scope="row">Attachment</th>
    <td colspan="3">
    <p  class="btn_sky"><a href="javascript:fn_memberListNew();">Download</a></p>
    </td>
</tr>
<tr>
    <th scope="row">Person Involved</th>
    <td colspan="3">
    <input type="text" title=""  name="personInvolved" id=""personInvolved"" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.memCode}"/>
    </td>
    <th scope="row">Case Category</th>
    <td colspan="3">
        <select class="w100p" id="caseCategory" name="caseCategory" onchange="fn_caseChange(this.value);">
             <c:forEach var="list" items="${caseCategoryCodeList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>
        </select>
    </td>

</tr>
<tr>

    <th scope="row"></th>
    <td colspan="3">
    </td>
    <th scope="row">Types of Documents</th>
    <td colspan="3">
    <select class="w100p"  id="docType" name="docType">
             <c:forEach var="list" items="${documentsCodeList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Feedback Content</th>
    <td colspan="7">
    <textarea cols="20" rows="5"  id="complianceRem"  readonly="readonly"  class="readonly"  name="complianceRem">${guardianofCompliance.reqstCntnt}</textarea>
    </td>
</tr>
<tr>
    <th scope="row">Request Date</th>
    <td colspan="3">
    <input type="text" title=""  name="reqDate" id="reqDate" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.reqstCrtDt}"/>
    </td>
    <th scope="row">Request By</th>
    <td colspan="3">
    <input type="text" title=""  name="reqBy" id="reqBy" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.userName}"/>
    </td>
</tr>
<tr>
    <th scope="row">Last Update At</th>
    <td colspan="3">
    <input type="text" title=""  name="updAt" id="updAt" class="readonly" style="width:100%;" readonly="readonly" value="${guardianofCompliance.reqstUpdDt}"/>
    </td>
    <th scope="row">Last Update By</th>
    <td colspan="3">
    <input type="text" title=""  name="updBy" id="updBy" class="readonly " style="width:100%;" readonly="readonly" value="${guardianofCompliance.userName1}"/>
    </td>
</tr>

    <tr id = "empty">

    <th scope="row"></th>
    <td colspan="7">
    </td>

</tr>

<tr id = "status">
    <th scope="row">Request Status</th>
    <td colspan="3">
    <select class="w100p"  id="cmbreqStatus" name="cmbreqStatus">
        <option value="60">In Progress</option>
        <option value="36">Closed</option>
        <option value="10">Cancelled</option>

    </select>
    </td>
    <th scope="row">Person In Charge</th>
    <td colspan="3">
        <select id="changePerson" name="changePerson" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Attachment</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="file1" accept=".rar, .zip"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='file1Txt'/>
                <span class='label_text'><a href='#'>File</a></span>
            </label>
        </div>
    </td>
</tr>
<tr id = "ccontent">
     <th scope="row">Complaint Content</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="Complaint Content" id="complianceContent" name="complianceContent"></textarea>
    </td>
</tr>

</tbody>
</table><!-- table end -->
</form>

    <ul class="center_btns" id="save">
        <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_save()">Save</a></p></li>
    </ul>







</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_remark" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->



</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
