<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,batchDeductionItemId;
var selectedGridValue;

$(document).ready(function(){
    var gridPros = {
            showStateColumn : false,
            softRemoveRowMode:false,
            editable            : false,
    };

    var gridProse = {
            usePaging           : true,             //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable                : false,
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
            selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       :  gridMsg["sys.info.grid.noDataMessage"],
            groupingMessage     : gridMsg["sys.info.grid.groupingMessage"]
        };

    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    batchDeductionItemId = GridCommon.createAUIGrid("#batchDeductionItem_grid_wrap", batchDeductionColumnLayout,null,gridProse);
    AUIGrid.resize(batchDeductionItemId,945, $(".batchDeductionItem_grid_wrap").innerHeight());

    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

});


function fn_chgContPerPopClose() {
    $('#chgContPerPop').hide();
    searchList();
}

var columnLayout = [
    { dataField:"custCrcId" ,headerText:"Cust CRC ID",width: '10%'},
    { dataField:"tokenId" ,headerText:"Token ID",width: '20%'},
    { dataField:"code" ,headerText:"Status",width: '5%'},
    { dataField:"cardType" ,headerText:"Card Type",width: '10%'},
    { dataField:"creditCardType" ,headerText:"Credit Card Type",width: '10%'},
    { dataField:"responseCode" ,headerText:"Response Code",width: '15%'},
    { dataField:"responseDesc" ,headerText:"Response Description",width: '10%'},
    { dataField:"remark" ,headerText:"Reason",width: '15%'},
    { dataField:"updDt" ,headerText:'<spring:message code="pay.head.updateDate" />',width: '15%'},
    { dataField:"updUserId" ,headerText:'<spring:message code="pay.head.updator" />',width: '10%'},
    ];

var batchDeductionColumnLayout= [
                                 {dataField : "custCrcToken", headerText : "Token ID", width : '20%'},
                                 {dataField : "salesOrdNo", headerText : "Sales Order No", width : '15%'},
                                 {dataField : "lastUpdateDate", headerText : "Last Update Date", width : '15%'},
                                 {dataField : "amount", headerText : "Amount", width : '10%'},
                                 {dataField : "customerName", headerText : "Customer Name", width : '20%'},
                                 {dataField : "thirdParty", headerText : "Third Party", width : '15%'},
                                 ];

function fn_uploadFile(){

    var formData = new FormData();
    var uploadStatus = $("#uploadStatus option:selected").val();

    if(uploadStatus == ""){
        Common.alert("* Please select the Status.");
        return;
    }

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("uploadStatus", uploadStatus);

    Common.ajaxFile("/payment/tokenIdMaintainCsvFileUploads.do", formData, function(result){
        $('#uploadStatus option[value=""]').attr('selected', 'selected');

        Common.alert(result.message);
    });
}

function fn_close(wrap, form) {
    $(wrap).hide();
    $(form)[0].reset();
}

$(function(){
    $('#search').click(function() {
        Common.ajax("GET", "/payment/selectTokenIdMaintain.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    });

    $('#clear').click(function() {
        $("#searchForm")[0].reset();
    });

    $('#btnUpload').click(function() {
        $('#upload_popup_wrap').show();
    })

    $('#btnCloseUpload').click(function() {
        fn_close('#upload_popup_wrap','');
    });


});

//View Claim Pop-UP
function fn_openDivPop(val){
    if(val == "VIEW"){

        var selectedItem = AUIGrid.getSelectedIndex(myGridID);

        if (selectedItem[0] > -1){

            var tokenId = AUIGrid.getCellValue(myGridID, selectedGridValue, "tokenId");
            var custCrcId = AUIGrid.getCellValue(myGridID, selectedGridValue, "custCrcId");

            if(val == "VIEW"){

            	Common.ajax("GET","/payment/selectTokenIdMaintainDetailPop.do", {"tokenId":tokenId,"custCrcId":custCrcId}, function(result){
                    AUIGrid.setGridData(batchDeductionItemId, result);
                });

            	$("#view_wrap").show();
            }
        }else{
             Common.alert('No claim record selected.');
        }
    }else{
        $("#view_wrap").hide();
    }
}

</script>
<!-- content start -->
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Payment</li>
    <li>Payment</li>
    <li>Customer VA Exclude</li>
  </ul>
  <!-- title_line start -->
  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>Token ID Maintenance</h2>
    <ul class="right_btns">
<%--       <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
      <li><p class="btn_blue"><a id="btnUpload">Upload</a></p></li>
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
<%--       </c:if> --%>
    </ul>
  </aside>
  <!-- title_line end -->
  <!-- search_table start -->
  <section class="search_table">
    <form name="searchForm" id="searchForm" method="post">
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 200px" />
          <col style="width: *" />
          <col style="width: 200px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">Response Code</th>
            <td><input id="responseCode" name="responseCode" type="text"/></td>
            <th scope="row">Credit Card Type</th>
            <td><input id="creditCardType" name="creditCardType" type="text"/></td>
        </tbody>
      </table>
      <!-- table end -->
                  <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');">View Details</a></p></li>
                        </c:if>
                    </ul>
                    <ul class="btns">
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->

    </form>
  </section>

   <section class="search_result">
    <!-- grid_wrap start -->
    <article>
            <div id="grid_wrap" class="grid_wrap" style="width:100%; height:480px; margin: 0 auto;" class="autoGridHeight"></div>
    </article>
  </section>
  <!-- search_table end -->
</section>
<!-- content end -->

<!---------------------------------------------------------------
    POP-UP (NEW CLAIM)
---------------------------------------------------------------->

<div id="upload_popup_wrap" class="popup_wrap size_small" style="display:none;"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Token ID Maintenance Upload</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="btnCloseUpload"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
        <form action="#" method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                      <th scope="row">Upload Status</th>
                      <td>
                        <select class="" id="uploadStatus" name="uploadStatus">
                            <option value="">Choose One</option>
                            <option value="1">Active</option>
                            <option value="8">Inactive</option>
                        </select>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">File</th>
                      <td>
                      <div class="auto_file"><!-- auto_file start -->
                          <input type="file" title="file add" id="uploadfile" name="uploadfile" />
                      </div><!-- auto_file end -->
                      </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/payment/TokenIdMaintain_Format.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
        </ul>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>Details</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                    <a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a>
                </p></li>
                  <!-- search_result start -->

			    <!-- grid_wrap start -->
        </ul>
    </header>
<section class="pop_body"><!-- pop_body start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="batchDeductionItem_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->


     </section><!-- pop_body end -->
    <!-- pop_header end -->
</div>
<!-- popup_wrap end -->
