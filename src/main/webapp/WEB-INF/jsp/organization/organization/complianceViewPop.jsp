<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_order;
var myGridID_remark;
$(document).ready(function(){ 
	fn_registerOrderGrid();
	fn_complianceRemarkGrid();
	fn_orderDetailCompliance();
	fn_complianceRemark();
	fn_searchMemberDetail();
	
});
function fn_registerOrderGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "salesOrdNo",
        headerText : "OrderNo",
        editable : false,
        width : 130
    }, {
        dataField : "c1",
        headerText : "OrderDate",
        editable : false,
        width : 130
    }, {
        dataField : "codeName",
        headerText : "App Type",
        editable : false,
        width : 130
    }, {
        dataField : "stkDesc",
        headerText : "Product",
        editable : false,
        width : 130
    }, {
        dataField : "name",
        headerText : "Status",
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "name1",
        headerText : "CustomerName",
        editable : false,
        width : 130
    }, {
        dataField : "salesOrdId",
        headerText : "a",
        editable : false,
        width : 0
    }, {
        dataField : "nric",
        headerText : "NRIC/Company",
        editable : false,
        width : 130
    }, {
        dataField : "cmplncId",
        headerText : "",
        editable : false,
        width : 0
    }, {
        dataField : "",
        headerText : "",
        width : 170,
        renderer : {
              type : "ButtonRenderer",
              labelText : "▶",
              onclick : function(rowIndex, columnIndex, value, item) {
                  
                  var salesOrdId = AUIGrid.getCellValue(myGridID_order, rowIndex, "salesOrdId");
                  Common.popupDiv("/organization/compliance/complianceOrderFullDetailPop.do?salesOrderId="+salesOrdId ,null, null , true , ''); 
                  }
        }      
 }];
     // 그리드 속성 설정
    var gridPros = {
        
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
             editable            : false,            
             fixedColumnCount    : 1,            
             showStateColumn     : false,             
             displayTreeOpen     : false,            
             selectionMode       : "singleRow",  //"multipleCells",            
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_order = AUIGrid.create("#grid_wrap_register", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false
    
};


function fn_complianceRemarkGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "name",
        headerText : "Case Status",
        editable : false,
        width : 80
    }, {
        dataField : "resnDesc",
        headerText : "Compliance F/Up",
        editable : false,
        width : 130
    }, {
        dataField : "name1",
        headerText : "Action",
        editable : false,
        width : 130
    }, {
        dataField : "cmplncColctAmt",
        headerText : "Amount",
        editable : false,
        width : 100
    }, {
        dataField : "cmplncRem",
        headerText : "Remark",
        editable : false,
        style : "my-column",
        width : 200
    }, {
        dataField : "userName",
        headerText : "Creator",
        editable : false,
        width : 130
    }, {
        dataField : "c1",
        headerText : "Create Date",
        editable : false,
        width : 130
    }, {
        dataField : "cmplncAtchFileGrpId",
        headerText : "Create Date",
        editable : false,
        width : 0
    }, {
        dataField : "",
        headerText : "Download Attachment",
        width : 170,
        renderer : {
              type : "ButtonRenderer",
              labelText : "Download",
              onclick : function(rowIndex, columnIndex, value, item) {
                  
                  var cmplncAtchFileGrpId = AUIGrid.getCellValue(myGridID_remark, rowIndex, "cmplncAtchFileGrpId");
                  Common.ajax("GET", "/organization/compliance/complianceAttachDownload.do", {cmplncAtchFileGrpId : cmplncAtchFileGrpId}, function(result) {
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
        }
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

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false
    
};

function fn_orderDetailCompliance(){
     Common.ajax("GET", "/organization/compliance/orderDetailComplianceId.do", {complianceId : "${complianceValue.cmplncId }"}, function(result) {
         console.log("성공.");
         AUIGrid.setGridData(myGridID_order, result);
         
     }); 
}
function fn_complianceRemark(){
    Common.ajax("GET", "/organization/compliance/complianceRemark.do", {complianceId : "${complianceValue.cmplncId }"}, function(result) {
        console.log("성공.");
        AUIGrid.setGridData(myGridID_remark, result);
        
    }); 
}
 function fn_searchMemberDetail(){
    Common.ajax("GET", "/organization/compliance/getMemberDetail.do", {memberCode :"${complianceValue.memId }"}, function(result) {
        console.log("성공.");
        
        if(result.memType == "1" || result.memType == "2" ||  result.memType == "3"){
            
            $("#ord1").html(result.orgCode+" (Organization Code)");
            $("#ord2").html(result.grpCode + " (Group Code)" );
            $("#ord3").html(result.deptCode + " (Department Code)");
            $("#code").html(result.memCode);
            $("#name").html(result.name);
            $("#nric").html(result.nric);
            $("#mbNo").html(result.telMobile);
            $("#offNo").html(result.telOffice);
            $("#houNo").html(result.telHuse);
            $("#memberId").val(result.memId);
            $("input[name=memberCode]").attr('disabled', 'disabled');
        }else{
            Common.alert("Only HP, Cody and CT can add to compliance call log");
        }
    });
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View Compliance Call Log</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
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
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case No</th>
    <td>
    <span>${complianceValue.cmplncNo }</span>
    </td>
    <th scope="row">Case Status</th>
    <c:if test="${complianceValue.cmplncStusId  == '1' }">
        <td>
        <span>Active</span>
        </td>
    </c:if>
    <c:if test="${complianceValue.cmplncStusId  == '60' }">
        <td>
        <span>In Progress</span>
        </td>
    </c:if>
    <c:if test="${complianceValue.cmplncStusId  == '36' }">
        <td>
        <span>Closed</span>
        </td>
    </c:if>
    <c:if test="${complianceValue.cmplncStusId  == '10'}">
        <td>
        <span>Cancel</span>
        </td>
    </c:if>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Member View</a></li>
    <li><a href="#"  onclick=" javascirpt:AUIGrid.resize(myGridID_order, 950,300);">Register Order</a></li>
    <li><a href="#" onclick="javascirpt:AUIGrid.resize(myGridID_remark, 950,300);">Compliance Remark</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Salesman Info</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="3">Order Made By</th>
    <td>
    <span id="ord1"></span>
    </td>
</tr>
<tr>
    <td>
    <span id="ord2"></span>
    </td>
</tr>
<tr>
    <td>
    <span id="ord3"></span>
    </td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td>
    <span id="code"></span>
    </td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td>
    <span id="name"></span>
    </td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td>
    <span id="nric"></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td>
    <span id="mbNo"></span>
    </td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td>
    <span id="offNo"></span>
    </td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td>
    <span id="houNo"></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->


</div><!-- border_box end -->

</div>

<div style="width:50%;">

<!-- <div class="border_box">border_box start
</div>border_box end -->

</div>

</div><!-- divine_auto end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_register" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_remark" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
