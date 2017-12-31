<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
    //AUIGrid 그리드 객체
    var myGridID;
    var myDetailGridID;
    
    //Grid에서 선택된 RowID
    var selectedGridValue;
    
    //Grid Properties 설정
    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,        
            // 상태 칼럼 사용
            showStateColumn : false,
            // 기본 헤더 높이 지정
            headerHeight : 35,
            
            softRemoveRowMode:false
    
    };
    
    var statusTypeData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"}];

    // AUIGrid 칼럼 설정
    var columnLayout = [ 
        {dataField : "crcStateId",headerText : "<spring:message code='pay.head.crcNo'/>",width : 120 , editable : false},
        {dataField : "crcTrnscDt",headerText : "<spring:message code='pay.head.transactionDate'/>",width : 150 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "crcStateUploadDt",headerText : "<spring:message code='pay.head.uploadDate'/>",width : 120 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "crcItmCnt",headerText : "<spring:message code='pay.head.count'/>",width : 100 , editable : false, dataType:"numeric", formatString:"#,##0"},
        {dataField : "crcStateRem",headerText : "<spring:message code='pay.head.remark'/>", editable : false},
        {dataField : "crcGrosAmt",headerText : "<spring:message code='pay.head.grossRm'/>",width : 120 , editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "bcAmt",headerText : "<spring:message code='pay.head.bcRm'/>",width : 120 , editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "gstAmt",headerText : "<spring:message code='pay.head.gstRm'/>",width : 120 , editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcPostngDt",headerText : "<spring:message code='pay.head.postingDate'/>",width : 150 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "crcStateUploadUserNm",headerText : "<spring:message code='pay.head.userName'/>",width : 150 , editable : false},
        {dataField : "crcBcStusId",headerText : "<spring:message code='pay.head.statsId'/>",width : 150 , editable : false}
        ];
    
        
    var detailColumnLayout = [
        {dataField : "crcTrnscId",headerText : "<spring:message code='pay.head.crcTransactionId'/>",editable : false, visible : false},
        {dataField : "crcTrnscMid",headerText : "<spring:message code='pay.head.mid'/>", editable : false},                    
        {dataField : "crcTrnscDt",headerText : "<spring:message code='pay.head.trDate'/>",editable : false, dataType:"date",formatString:"dd/mm/yyyy"},                    
        {dataField : "crcTrnscNo",headerText : "<spring:message code='pay.head.cardNo'/>", editable : false},
        {dataField : "crcTrnscAppv",headerText : "<spring:message code='pay.head.approvalNo'/>", editable : false},                    
        {dataField : "crcGrosAmt",headerText : "<spring:message code='pay.head.grossRm'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcBcAmt",headerText : "<spring:message code='pay.head.bcRm'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcGstAmt",headerText : "<spring:message code='pay.head.gstRm'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcNetAmt",headerText : "<spring:message code='pay.head.netRm'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcTotBcAmt",headerText : "<spring:message code='pay.head.totalBc'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},                    
        {dataField : "crcTotGstAmt",headerText : "<spring:message code='pay.head.totalGst'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "crcTotNetAmt",headerText : "<spring:message code='pay.head.totalNet'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"}
        ];    
    
    $(document).ready(function(){
        
        //Credit Card Bank Account 조회
        doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'bankAccount' , 'S', '');
        
        //상태값 combo box 세팅
        doDefCombo(statusTypeData, '' ,'status', 'S', '');    
        
        //그리드 생성
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
        myDetailGridID = GridCommon.createAUIGrid("detail_grid_wrap", detailColumnLayout,null,gridPros);
        
        
        // Master Grid 셀 클릭시 이벤트
        AUIGrid.bind(myGridID, "cellClick", function( event ){ 
            selectedGridValue = event.rowIndex;
        });
        
        
    });

    // ajax list 조회.
    function searchList(){
    	
        if(FormUtil.checkReqValue($("#bankAccount option:selected")) &&
        		FormUtil.checkReqValue($("#status option:selected")) &&
        		FormUtil.checkReqValue($("#crcStateId")) &&
                FormUtil.checkReqValue($("#tranDateFr")) &&
                FormUtil.checkReqValue($("#tranDateTo")) &&
                FormUtil.checkReqValue($("#uploadDateFr")) &&
                FormUtil.checkReqValue($("#uploadDateTo")) ){
            Common.alert("<spring:message code='pay.alert.searchCondition'/>");
            return;
        }
        
        if((!FormUtil.checkReqValue($("#tranDateFr")) && FormUtil.checkReqValue($("#tranDateTo"))) ||
                (FormUtil.checkReqValue($("#tranDateFr")) && !FormUtil.checkReqValue($("#tranDateTo"))) ){
            Common.alert("<spring:message code='pay.alert.inputTransactionDate'/>");
            return;
        }
        
        if((!FormUtil.checkReqValue($("#uploadDateFr")) && FormUtil.checkReqValue($("#uploadDateTo"))) ||
                (FormUtil.checkReqValue($("#uploadDateFr")) && !FormUtil.checkReqValue($("#uploadDateTo"))) ){
            Common.alert("<spring:message code='pay.alert.inputUploadDate'/>");
            return;
        }
        
        Common.ajax("POST","/payment/selectCRCConfirmMasterList.do",$("#searchForm").serializeJSON(), function(result){          
            AUIGrid.setGridData(myGridID, result);
        });
    }
    
    // 화면 초기화
    function clear(){
        //화면내 모든 form 객체 초기화
        $("#searchForm")[0].reset();
        
        //그리드 초기화
        //AUIGrid.clearGridData(myGridID);
        //AUIGrid.clearGridData(myDetailGridID);
        //AUIGrid.clearGridData(myUploadGridID);       
    }
    
  //Layer close
  hideViewPopup=function(val){       
      $(val).hide();
  }
  
  function postStatement(){
	    var selectedItem = AUIGrid.getSelectedIndex(myGridID);

	    if (selectedItem[0] > -1){
	        var crcStateId = AUIGrid.getCellValue(myGridID, selectedGridValue, "crcStateId");
	        var crcBcStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "crcBcStusId");
	        
	        if(crcBcStusId != 1){
	        	Common.alert("<spring:message code='pay.alert.onlyActiveStatus'/>");
	        }else{
	        	Common.confirm("<spring:message code='pay.alert.saveThisForm'/>",
	                    function(){
	                        Common.ajax("GET","/payment/postCardStatement.do", {"crcStateId" : crcStateId}, 
	                            function(result){
	                                Common.alert("<spring:message code='pay.alert.formSuccessSaved'/>", 
	                                    function (){
	                                        searchList();  
	                                    }
	                                );
	                            }
	                        );
	                    }
	        	   );
	        }
	        
	    }else{
	        Common.alert("<spring:message code='pay.alert.noRecord'/>");
	    }
	}
  
  function detailStatement(){
      var selectedItem = AUIGrid.getSelectedIndex(myGridID);

      if (selectedItem[0] > -1){
          var crcStateId = AUIGrid.getCellValue(myGridID, selectedGridValue, "crcStateId");

          Common.ajax("GET","/payment/selectCardStatementDetailList.do", {"crcStateId" : crcStateId}, function(result){
              $("#detail_wrap").show();
              
              AUIGrid.setGridData(myDetailGridID, result);
              AUIGrid.resize(myDetailGridID);
          });
      }else{
          Common.alert("<spring:message code='pay.head.noRecord'/>");
      }
  }
  
</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Confirm Bank Charge & GST</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:postStatement();"><spring:message code='pay.btn.posting'/></a></p></li>
           </c:if>
           <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:detailStatement();"><spring:message code='pay.btn.detailed'/></a></p></li>
           </c:if>
             <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a href="javascript:clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">CRC No.</th>
                        <td>
                            <input type="text" id="crcStateId" name="crcStateId" title="CRC Statement ID" placeholder="CRC No" class="w100p" />
                        </td>
                        <th scope="row"></th>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td>
                            <select id="status" name="status" class="w100p"></select>
                        </td>
                        <th scope="row">Bank Account</th>
                        <td>
                            <select id="bankAccount" name="bankAccount" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Transaction Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="tranDateFr" name="tranDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="tranDateTo" name="tranDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        <th scope="row">Upload Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="uploadDateFr" name="uploadDateFr" title="Upload Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="uploadDateTo" name="uploadDateTo" title="Upload End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->



<!--------------------------------------------------------------- 
POP-UP (DETAIL)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="detail_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="detail_pop_header">
        <h1>Credit Card Statement Item</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#detail_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <section class="search_result">
            <article class="grid_wrap"  id="detail_grid_wrap"></article>  
        </section>
        <!-- search_table end -->
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->