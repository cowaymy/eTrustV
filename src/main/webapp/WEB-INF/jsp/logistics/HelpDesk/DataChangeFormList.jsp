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


</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var comboData = [{"codeId": "0","codeName": "New"},{"codeId": "61","codeName": "Verifying"},{"codeId": "5","codeName": "Approved"},{"codeId": "6","codeName": "Rejected"},{"codeId": "36","codeName": "Closed"}];
var cmbStatusCombo= [{"codeId": "61","codeName": "Verifying"},{"codeId": "36","codeName": "Approve & Close"},{"codeId": "6","codeName": "Rejected"}];
    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGridID;
    var dcfreqentryid;
    var div;

    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"dcfreqno"      ,headerText:"Request No"           ,width:"10%"  ,height:30 , visible:true},
                                  {dataField:"c11"      ,headerText:"Request Date"           ,width:"10%" ,height:30 , visible:true},
                                  {dataField:"code"      ,headerText:"Request Status"    ,width:"11%" ,height:30 , visible:true},
                                  {dataField:"dcfsuptypedesc"      ,headerText:"Type"           ,width:"15%"  ,height:30 , visible:true},
                                  {dataField:"dcfsuptypedesc1"      ,headerText:"Category"           ,width:"14%" ,height:30 , visible:true},
                                  {dataField:"dcfsuptypedesc2"      ,headerText:"Subject"    ,width:"15%" ,height:30 , visible:true},
                                  {dataField:"c12"      ,headerText:"Requestor"           ,width:"12.5%" ,height:30 , visible:true},
                                  {dataField:"c6"      ,headerText:"Approval Status"    ,width:"12.5%" ,height:30 , visible:true},
                                  {dataField:"dcfreqentryid"      ,headerText:"Approval Status"    ,width:"12.5%" ,height:30 , visible:false},
                                  {dataField:"name"      ,headerText:"Request Status"           ,width:"10%" ,height:30 , visible:false},
                                  {dataField:"c20"      ,headerText:"Request By"    ,width:"15%" ,height:30 , visible:false},
                                  {dataField:"dcfreqremark"      ,headerText:"Remark"           ,width:"12.5%" ,height:30 , visible:false},
                                  {dataField:"dcfReqDesc"      ,headerText:"Description"    ,width:"15%" ,height:30 , visible:false},
                                  {dataField:"c19"      ,headerText:"Request On Behalf"           ,width:"15%"  ,height:30 , visible:false},
                                  {dataField:"c21"      ,headerText:"Settle Date"           ,width:"15%"  ,height:30 , visible:false},
                       
                                  {dataField:"dcfreqapproveremark"      ,headerText:"DCFReqApproveRemark"           ,width:"15%"  ,height:30 , visible:false},
                                  {dataField:"dcfreqapproveby"      ,headerText:"DCFReqApproveBy"           ,width:"15%"  ,height:30 , visible:false},
                                  {dataField:"reasondesc1"      ,headerText:"Reason (Approver Verified)"           ,width:"15%"  ,height:30 , visible:false},
                                  {dataField:"c7"      ,headerText:"Approval Status"           ,width:"15%"  ,height:30 , visible:false},
                                  {dataField:"c2"      ,headerText:"Approve At"           ,width:"15%"  ,height:30 , visible:false},
                                  {dataField:"dcfreqstatusid"      ,headerText:"DCF_REQ_STUS_ID"           ,width:"15%"  ,height:30 , visible:false},
                                                                      
                               ];
    
    
        var compulsoryLayout = [{dataField:"dcfComFildTypeName"      ,headerText:"Field Type"           ,width:"50%"  ,height:30 , visible:true},
                            {dataField:"dcfReqComFildRefNo"      ,headerText:"Reference"           ,width:"50%" ,height:30 , visible:true},         
                  
                         ];
        var changeitemLayout = [{dataField:"dcfReqDetFildChg"      ,headerText:"Item"           ,width:"15%"  ,height:30 , visible:true},
                            {dataField:"dcfReqDetOldData"      ,headerText:"From"           ,width:"15%" ,height:30 , visible:true},
                            {dataField:"dcfReqDetNwData"      ,headerText:"To"    ,width:"15%" ,height:30 , visible:true},
                            {dataField:"c3"      ,headerText:"Status"           ,width:"15%"  ,height:30 , visible:true},
                            {dataField:"c4"      ,headerText:"Settle Date"           ,width:"15%" ,height:30 , visible:true},
                            {dataField:"dcfReqDetRem"      ,headerText:"Remark"    ,width:"20%" ,height:30 , visible:true},      
                         ];
        var respondlogLayout = [{dataField:"c2"      ,headerText:"Creator"           ,width:"30%"  ,height:30 , visible:true},
                            {dataField:"c1"      ,headerText:"Date"           ,width:"30%" ,height:30 , visible:true},
                            {dataField:"dcfRespnsMsg"      ,headerText:"Remark"    ,width:"40%" ,height:30 , visible:true},
                         ];
    
    
            
 /* 그리드 속성 설정
  usePaging : true, pageRowCount : 30,  fixedColumnCount : 1,// 페이지 설정
  editable : false,// 편집 가능 여부 (기본값 : false) 
  enterKeyColumnBase : true,// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
  selectionMode : "multipleCells",// 셀 선택모드 (기본값: singleCell)                
  useContextMenu : true,// 컨텍스트 메뉴 사용 여부 (기본값 : false)                
  enableFilter : true,// 필터 사용 여부 (기본값 : false)            
  useGroupingPanel : true,// 그룹핑 패널 사용
  showStateColumn : true,// 상태 칼럼 사용
  displayTreeOpen : true,// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
  noDataMessage : "출력할 데이터가 없습니다.",
  groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
  rowIdField : "stkid",
  enableSorting : true,
  showRowCheckColumn : true,
  */
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    
/*     var subgridpros = {
            // 페이지 설정
            usePaging : true,                
            pageRowCount : 10,                
            editable : true,                
            noDataMessage : "출력할 데이터가 없습니다.",
            enableSorting : true,
            softRemoveRowMode:false
            }; */
     
    
        $(document).ready(function(){
            // masterGrid 그리드를 생성합니다.
            myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
             
            
            doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','searchRequestBranch', 'M' , 'f_multiCombo'); //Branch 리스트 조회
            doGetCombo('/logistics/assetmng/selectDepartmentList.do', '42', '','searchRequestDepartment', 'M' , 'f_DepartmentList'); //Department 리스트 조회
            doDefCombo(comboData, '' ,'searchApprovalStatus', 'M', 'f_ApprovalStatusList'); //Approval Status 리스트 조회
            
          $("#ViewPopUp_wrap").hide(); 
            
            AUIGrid.bind(myGridID, "cellClick", function( event )  
            {
                
                
           });
            
            // 셀 더블클릭 이벤트 바인딩
            AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
            {
                 var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                   if (selectedItem[0] > -1){
                     dcfreqentryid = AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqentryid');
                       
                     $("#ViewPopUp_wrap").show();  
                        //getDetailInfoListAjax(dcfreqentryid,div);
                   
                        fn_DataChangeDetail(selectedItem[0]);
                        CompulsoryFieldGridID = GridCommon.createAUIGrid("CompulsoryFieldGrid_wrap", compulsoryLayout,"", gridoptions); 
                        ChangeItemGridID = GridCommon.createAUIGrid("ChangeItemGrid_wrap", changeitemLayout,"", gridoptions); 
                        RespondLogGridID = GridCommon.createAUIGrid("RespondLogGrid_wrap", respondlogLayout,"", gridoptions);    
                     
                   //$("#AddApporovalBtn").show();  
                   }else{
                   Common.alert('Choice Data please..');
                   }
            
                
            });
           
            /* 팝업 드래그 start */
                $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
                /* 팝업 드래그 end */
                });
        
        
        
    
        $(function(){
             $("#search").click(function(){
                 getDataChangeListAjax();  
              });  
             
             $("#insert").click(function(){
                 var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                 if (selectedItem[0] > -1){
                   dcfreqentryid = AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqentryid');
                   fn_DataChangeDetail(selectedItem[0]);
                   $("#ViewPopUp_wrap").show();
                   $("#insertDataChange").show();
                   $("#AddApporovalBtn").show();
                   doDefCombo(cmbStatusCombo, '' ,'insApprovalStatus', 'S', ''); //Approval Status 리스트 조회
                   doGetCombo('/logistics/helpdesk/selectReasonList.do', '', '','insReason', 'S' , '');//Reason  리스트 조회
           
                   CompulsoryFieldGridID = GridCommon.createAUIGrid("CompulsoryFieldGrid_wrap", compulsoryLayout,"", gridoptions); 
                   ChangeItemGridID = GridCommon.createAUIGrid("ChangeItemGrid_wrap", changeitemLayout,"", gridoptions); 
                   RespondLogGridID = GridCommon.createAUIGrid("RespondLogGrid_wrap", respondlogLayout,"", gridoptions);    
                   
                 
                 }else{
                 Common.alert('Choice Data please..');
                 }
                    
              });  
             
             
            $("#Approval_info").click(function(){
                 div="Approval_info";
                 var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                 dcfreqentryid = AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqentryid');
                 getDetailInfoListAjax(dcfreqentryid,div);
            }); 
            $("#Compulsory_info").click(function(){
                div="Compulsory";
                destory(CompulsoryFieldGridID);
                
                var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                dcfreqentryid = AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqentryid');
                getDetailInfoListAjax(dcfreqentryid,div);
                CompulsoryFieldGridID = GridCommon.createAUIGrid("CompulsoryFieldGrid_wrap", compulsoryLayout,"", gridoptions);
                AUIGrid.resize(CompulsoryFieldGridID,div); 
            });
            $("#ChangeItem_info").click(function(){
                div="ChangeItem";
                destory(ChangeItemGridID);
                
                var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                dcfreqentryid = AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqentryid');
                getDetailInfoListAjax(dcfreqentryid,div);
                ChangeItemGridID = GridCommon.createAUIGrid("ChangeItemGrid_wrap", changeitemLayout,"", gridoptions);
                AUIGrid.resize(ChangeItemGridID,div); 
            });
            $("#RespondLog_info").click(function(){
                div="RespondLog";
                destory(RespondLogGridID);
                
                var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                dcfreqentryid = AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqentryid');
                getDetailInfoListAjax(dcfreqentryid,div);
                RespondLogGridID = GridCommon.createAUIGrid("RespondLogGrid_wrap", respondlogLayout,"", gridoptions);
                AUIGrid.resize(RespondLogGridID); 
            });
         
     
            
    });
    
    function getDataChangeListAjax() {
        
        Common.ajax("GET", "/logistics/helpdesk/selectDataChangeList.do",  $('#SearchForm').serialize(), function(result) {
          var gridData = result;             
                      
          AUIGrid.setGridData(myGridID, gridData.data); 
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
} 
    
    function getDetailInfoListAjax(dcfreqentryid,div) {
        var param;      
        param={"dcfreqentryid" :dcfreqentryid };
        
        Common.ajax("POST", "/logistics/helpdesk/DetailInfoList.do", param, function(result) {
            
          var gridData = result;  
            
         $("#viewApprovalStatus").val(result.data4[0].c6);
         $("#viewApproveAt").val(result.data4[0].c1);
         $("#viewApproveBy").val(result.data4[0].c2);
         $("#viewApproverVerified").val(result.data4[0].c3);
         $("#viewApprovalRemark").val(result.data4[0].dcfReqAppvRem);
         AUIGrid.setGridData(CompulsoryFieldGridID, gridData.data1);
         AUIGrid.setGridData(ChangeItemGridID, gridData.data2);
         AUIGrid.setGridData(RespondLogGridID, gridData.data3);   
         AUIGrid.resize(CompulsoryFieldGridID);
         AUIGrid.resize(ChangeItemGridID);
         AUIGrid.resize(RespondLogGridID);
          
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
} 
    
    
    
    function insertDataChangeAjax(dcfreqentryid) { 
        var param;      
        
        param=$('#AddApprovalForm').serializeJSON();
        
        Common.ajax("POST", "/logistics/helpdesk/insertDataChangeList.do", param, function(result) {
          var gridData = result;  
          $("#AddApprovalForm")[0].reset(); 
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
}
    
    
    
    function fn_DataChangeDetail(rowid){
        
         $("#viewDCFNumber").val(AUIGrid.getCellValue(myGridID ,rowid,'dcfreqno'));
         $("#viewRequestStatus").val(AUIGrid.getCellValue(myGridID ,rowid,'name'));
         $("#viewRequestDate").val(AUIGrid.getCellValue(myGridID ,rowid,'c11'));      
         $("#viewType").val(AUIGrid.getCellValue(myGridID ,rowid,'dcfsuptypedesc'));  
         
         $("#viewProgressStatus").val(AUIGrid.getCellValue(myGridID ,rowid,'c16'));     
         $("#viewRequestBy").val(AUIGrid.getCellValue(myGridID ,rowid,'c20'));        
         //$("#viewTransitLocation").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitFrom') +" To "+ AUIGrid.getCellValue(myGridID ,rowid,'trnsitTo'));
         $("#viewCategory").val(AUIGrid.getCellValue(myGridID ,rowid,'dcfsuptypedesc1'));
//          $("#viewSettleDate").val(AUIGrid.getCellValue(myGridID ,rowid,''));
//          $("#viewPriorityLevel").val(AUIGrid.getCellValue(myGridID ,rowid,''));
         $("#viewSubject").val(AUIGrid.getCellValue(myGridID ,rowid,'dcfsuptypedesc2'));   
         $("#viewRequestBranch").val(AUIGrid.getCellValue(myGridID ,rowid,'c9') +"-"+ AUIGrid.getCellValue(myGridID ,rowid,'c10'));  
         $("#viewRequestDepartment").val(AUIGrid.getCellValue(myGridID ,rowid,'c14'));     
         $("#viewRequestOnBehalf").val(AUIGrid.getCellValue(myGridID ,rowid,'c19'));
         $("#viewReason").val(AUIGrid.getCellValue(myGridID ,rowid,'c18'));
         $("#viewDescription").val(AUIGrid.getCellValue(myGridID ,rowid,'dcfreqdesc'));
         $("#viewRemark").val(AUIGrid.getCellValue(myGridID ,rowid,'dcfReqRem'));
         
         
    }
    
    function fn_insertDataChangeInfo() {
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);        
        $("#reqId").val(AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqentryid'));
        $("#DcfReqStatusId").val(AUIGrid.getCellValue(myGridID ,selectedItem[0],'dcfreqstatusid'));
        if(valiedcheck()){
        insertDataChangeAjax();
        }   
        
    }
    
    function valiedcheck() {   
        
        if ($("#insApprovalStatus").val() == "") {
            Common.alert("* Please select the approval status.");
            $("#insApprovalStatus").focus();
            return false;
        }
        
        if ($("#insApprovalRemark").val() == "") {
            Common.alert("* Please key in the approval remark.");
            $("#insApprovalRemark").focus();
            return false;
        }
   
        return true;
    }
    
  
    
    function f_multiCombo() {
        $(function() {
            $('#searchRequestBranch').multipleSelect({
                //selectAll : true, // 전체선택 
                width : '80%'
            }).multipleSelect("checkAll");          
        });
    }
    function f_DepartmentList() {
        $('#searchRequestDepartment').multipleSelect({
                //selectAll : true, // 전체선택 
                width : '100%'
            })
    }
    function f_ApprovalStatusList() {
        $(function() {            
             $('#searchApprovalStatus').multipleSelect({
                 //selectAll : true, // 전체선택 
                 width : '100%'  
             }).multipleSelect("setSelects", [0, 61]);          
            
          });       
    }
    function destory(gridNm) {
        AUIGrid.destroy(gridNm);
    }
    
    
    /*----------------------------------------   셀렉트박스 이벤트 시작 ---------------------------------------------------- */
    function getComboRelays(obj, value, tag, selvalue) {
        alert("value :    "+value);
        var robj = '#' + obj;
       if (value == "36") {
            $(robj).attr("disabled", false);
        }else{
            $("#insReason").prop('disabled', true);
        }
    }
    
      
</script>
<body>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Data Change Form List (* Only TR Book Lost)</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
<!--     <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="SearchForm" name="SearchForm"   method="get">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">DCF No</th>
    <td>
    <input type="text" id="searchDcfNo" name="searchDcfNo" title="" placeholder="DCF Number" class="w100p" />
    </td>
    <th scope="row">Requestor</th>
    <td>
    <input type="text" id="searchRequestor" name="searchRequestor"  title="" placeholder="Requestor (Username)" class="w100p" />
    </td>
    <th scope="row">Request Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" id="searchReqDate1" name="searchReqDate1" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" id="searchReqDate2" name="searchReqDate2" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Type</th>
    <td>
    <select class="disabled w100p" disabled="disabled">
        <option value=""></option>
        <option value=""></option>
        <option value=""></option>
    </select>
    </td>
    <th scope="row">Category</th>
    <td>
    <select class="disabled w100p" disabled="disabled">
        <option value=""></option>
        <option value=""></option>
        <option value=""></option>
    </select>
    </td>
    <th scope="row">Subject</th>
    <td>
    <select class="disabled w100p" disabled="disabled">
        <option value=""></option>
        <option value=""></option>
        <option value=""></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Approval Status  </th>
    <td>
      <select id="searchApprovalStatus"  name="searchApprovalStatus" >
    </select>
    </td>
    <th scope="row">Request Branch</th>
    <td>
      <select id="searchRequestBranch"  name="searchRequestBranch" class="multy_select w100p" multiple="multiple">
    </select>
    </td>
    <th scope="row">Request Department</th>
    <td>
   <select id="searchRequestDepartment"  name="searchRequestDepartment" >
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<!-- <aside class="link_btns_wrap">link_btns_wrap start -->
<%-- <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
<!-- <dl class="link_list"> -->
<!--     <dt>Link</dt> -->
<!--     <dd> -->
<!--     <ul class="btns"> -->
<!--         <li><p class="link_btn"><a href="#">menu1</a></p></li> -->
<!--         <li><p class="link_btn"><a href="#">menu2</a></p></li> -->
<!--         <li><p class="link_btn"><a href="#">menu3</a></p></li> -->
<!--         <li><p class="link_btn"><a href="#">menu4</a></p></li> -->
<!--         <li><p class="link_btn"><a href="#">Search Payment</a></p></li> -->
<!--         <li><p class="link_btn"><a href="#">menu6</a></p></li> -->
<!--         <li><p class="link_btn"><a href="#">menu7</a></p></li> -->
<!--         <li><p class="link_btn"><a href="#">menu8</a></p></li> -->
<!--     </ul> -->
<!--     <ul class="btns"> -->
<!--         <li><p class="link_btn type2"><a href="#">menu1</a></p></li> -->
<!--         <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li> -->
<!--         <li><p class="link_btn type2"><a href="#">menu3</a></p></li> -->
<!--         <li><p class="link_btn type2"><a href="#">menu4</a></p></li> -->
<!--         <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li> -->
<!--         <li><p class="link_btn type2"><a href="#">menu6</a></p></li> -->
<!--         <li><p class="link_btn type2"><a href="#">menu7</a></p></li> -->
<!--         <li><p class="link_btn type2"><a href="#">menu8</a></p></li> -->
<!--     </ul> -->
<%--     <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p> --%>
<!--     </dd> -->
<!-- </dl> -->
<!-- </aside>link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<!--     <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li> -->
<!--     <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li> -->
<!--     <li><p class="btn_grid"><a href="#">DEL</a></p></li> -->
    <li><p class="btn_grid"><a id="insert">INS</a></p></li>
<!--     <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap"></div>

</article><!-- grid_wrap end -->

</section><!-- search_result end -->


</section><!-- content end -->


        
</section><!-- container end -->
<hr />

<div id="ViewPopUp_wrap" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Data Change Form - View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->

<ul class="tap_type1">
    <li id="DCF_info" class="on"><a href="#">DCF Info</a></li>
    <li id="Approval_info"><a href="#">Approval Info</a></li>
    <li id="Compulsory_info"><a href="#">Compulsory Field</a></li>
    <li id="ChangeItem_info"><a href="#">Change Item(s)</a></li>
   <li id="RespondLog_info"><a href="#">Respond Log</a></li>     
</ul>

<article class="tap_area"><!-- tap_area start -->
<form id="dcfInfoForm" name="dcfInfoForm"   method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:145px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">DCF Number</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewDCFNumber" name="viewDCFNumber"/>
    </td>
    <th scope="row">Request Status</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewRequestStatus" name="viewRequestStatus"/>
    </td>
    <th scope="row">Request Date</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewRequestDate" name="viewRequestDate"/>
    </td>
</tr>
<tr>
    <th scope="row">Type</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewType" name="viewType"/>
    </td>
    <th scope="row">Progress Status</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewProgressStatus" name="viewProgressStatus"/>
    </td>
    <th scope="row">Request By</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewRequestBy" name="viewRequestBy"/>
    </td>
</tr>
<tr>
    <th scope="row">Category</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewCategory" name="viewCategory"/>
    </td>
    <th scope="row">Settle Date</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewSettleDate" name="viewSettleDate"/>
    </td>
    <th scope="row">Priority Level</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewPriorityLevel" name="viewPriorityLevel"/>
    </td>
</tr>
<tr>
    <th scope="row">Subject</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewSubject" name="viewSubject"/>
    </td>
    <th scope="row">Request Branch</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewRequestBranch" name="viewRequestBranch"/>
    </td>
    <th scope="row">Request Department</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewRequestDepartment" name="viewRequestDepartment"/>
    </td>
</tr>
<tr>
    <th scope="row">Request On Behalf</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewRequestOnBehalf" name="viewRequestOnBehalf"/>
    </td>
    <th scope="row">Reason</th>
    <td colspan="3">
    <input type="text" title="" placeholder=""  class="w100p" id="viewReason" name="viewReason"/>
    </td>
</tr>
<tr>
    <th scope="row">Description</th>
    <td colspan="5">
    <input type="text" title="" placeholder=""  class="w100p" id="viewDescription" name="viewDescription"/>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
    <input type="text" title="" placeholder=""  class="w100p" id="viewRemark" name="viewRemark"/>
    </td>
</tr>
<tr>
    <th scope="row">Attachment</th>
    <td colspan="5">
    <p class="btn_sky"><a href="#">Download Attachment</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:145px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Approval Status</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewApprovalStatus" name="viewApprovalStatus"/>
    </td>
    <th scope="row">Approve At</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewApproveAt" name="viewApproveAt"/>
    </td>
    <th scope="row">Approve By</th>
    <td>
    <input type="text" title="" placeholder=""  class="w100p" id="viewApproveBy" name="viewApproveBy"/>
    </td>
</tr>
<tr>
    <th scope="row">Reason (Approver Verified)</th>
    <td colspan="5">
    <input type="text" title="" placeholder=""  class="w100p" id="viewApproverVerified" name="viewApproverVerified"/>
    </td>
</tr>
<tr>
    <th scope="row">Approval Remark</th>
    <td colspan="5">
    <input type="text" title="" placeholder=""  class="w100p" id="viewApprovalRemark" name="viewApprovalRemark"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="CompulsoryFieldGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ChangeItemGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="RespondLogGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->


<form id="AddApprovalForm" name="AddApprovalForm"   method="post">
<table id="insertDataChange"  style="display: none;"  class="type1 mt30" ><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<input type="hidden" id="reqId" name="reqId"/>
<input type="hidden" id="DcfReqStatusId" name="DcfReqStatusId"/>
<tr>
    <th scope="row">Approval Status<span class="must">*</span></th>
    <td>
   <select id="insApprovalStatus"  name="insApprovalStatus" onchange="getComboRelays('insReason' , this.value , '', '')" >
    </select>
    </td>
    <th scope="row">Reason </th>
    <td>
    <select id="insReason"  name="insReason"  disabled="disabled">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Approval Remark<span class="must">*</span></th>
    <td colspan="3">
    <textarea id="insApprovalRemark" name="insApprovalRemark"  cols="20" rows="5" placeholder=""></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li id="AddApporovalBtn" style="display: none;"><p class="btn_blue2 big"><a onclick="javascript:fn_insertDataChangeInfo();">SAVE</a></p></li>
</ul>
</section><!-- pop_body end -->

</div>

</div><!-- wrap end -->
</body>
</html>