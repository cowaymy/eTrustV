<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

/* 커스텀 열 스타일 */
.my-column-style {
    background:#eeeeee;
    color:#005500;
    font-weight:bold;
}
/* 커스텀 열 스타일 */
.my-column-style2 {
    background:#FFEBFE;
    color:#0000ff;
}
</style>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var  myGridID;

    $(document).ready(function(){

        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        $("#download").click(function() {
            GridCommon.exportTo("ord_grid", 'xlsx', "Order Serial No. History List");
        });
        
        var roleId = '${SESSION_INFO.roleId}';
        if(roleId == 256 || "${SESSION_INFO.userTypeId}" == "2"){
            $("#ordNo").attr("readonly", true);
        }
    });

    /* salesOrdId
    salesOrdNo
    itmCode
    stkDesc
    seq
    callGbn
    refDocNo
    afSerialNo
    bfSerialNo
    lastInstallSerialNo
    mobileYn
    crtBrnchId
    crtUserBrnchNm
    crtUserId
    crtUserNm
    crtDt */

    function createAUIGrid(){
        //AUIGrid 칼럼 설정
        var ordGridrLayout = [
          {   dataField : "salesOrdNo", headerText : 'Order No.',         width : 120 }
         ,{   dataField : "itmCode", headerText : 'Item Code',     width : 120 }
         ,{   dataField : "stkDesc", headerText : 'Item Name',     width : 220, style: "aui-grid-user-custom-left" }
         ,{   dataField : "callGbn", headerText : 'Call Screen',     width : 120 }
         ,{   dataField : "refDocNo", headerText : 'Ref Doc No.',         width : 120 }
         ,{   dataField : "bfSerialNo", headerText : 'Before Serial No.',        width : 160 }
         ,{   dataField : "afSerialNo", headerText : 'After Serial No.',   width : 160, style:"my-column-style2" }
         ,{   dataField : "lastInstallSerialNo",  headerText : 'Install Serial No.',     width : 160  }
         ,{   dataField : "crtUserBrnchCd", headerText : 'Change Branch',      width : 120, style: "aui-grid-user-custom-left" }
         ,{   dataField : "crtUserFullName", headerText : 'Change User',        width : 180, style: "aui-grid-user-custom-left" }
         ,{   dataField : "crtDt", headerText : 'Change Date Time',    width : 160 }
        ];

     //그리드 속성 설정
     var ordGridPros = {
         usePaging                  : true,             //페이징 사용
         pageRowCount           : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
         editable                     : false,
         showStateColumn        : false,
         showRowNumColumn    : false,
         headerHeight              : 30
       //selectionMode       : "singleRow"  //"multipleCells",
     };

     myGridID = GridCommon.createAUIGrid("ord_grid", ordGridrLayout, "", ordGridPros);
 }

 function fn_search(){

//	 console.log("++++ ::" + FormUtil.isEmpty($("#serialNo").val()) + ", " + FormUtil.isEmpty($("#refDocNo").val()) + ", " + FormUtil.isEmpty($("#ordNo").val()) );
	 if( !FormUtil.isEmpty($("#serialNo").val()) || !FormUtil.isEmpty($("#refDocNo").val()) || !FormUtil.isEmpty($("#ordNo").val()) ){

	 }else{
		    if( FormUtil.isEmpty($("#startCrtDt").val()) || FormUtil.isEmpty($("#endCrtDt").val()) ){
		    	Common.alert("<spring:message code='sys.msg.necessary' arguments='Change Date' htmlEscape='false'/>");
		    	return false;
		    }
	 }

	Common.ajax("GET", "/logistics/serialHistory/selectSerialHistoryList", $("#dataForm").serialize(), function(result) {
	  AUIGrid.setGridData(myGridID, result);
	});
 }

</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Serial No. History</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="window.close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section style="max-height:none; padding:10px; background:#fff; padding-top: 60px"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<!-- <h2>Order Serial No. History</h2> -->

  <ul class="right_btns">
    <li><p class="btn_blue">
      <a href="#" onclick="javascript:fn_search()">
        <spring:message code="sal.btn.search" /></a>
     </p></li>
     </ul>

</aside><!-- title_line end -->

<form id="dataForm" name="dataForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
     <tr>
      <th scope="row">Change Date</th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" id="startCrtDt" name="startCrtDt"
          title="Create start Date" value="${bfDay}"
          placeholder="DD/MM/YYYY" class="j_date" />
        </p>
        <span><spring:message code="sal.text.to" /></span>
        <p>
         <input type="text" id="endCrtDt" name="endCrtDt"
          title="Create end Date" value="${toDay}"
          placeholder="DD/MM/YYYY" class="j_date" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <th scope="row">Change Branch ID / Name</th>
      <td>
        <input type="text" title="" id="schBranch" name="schBranch"
            placeholder="Change Branch ID / Name" class="w100p" />
      </td>
      <th scope="row">Change User ID / Name</th>
      <td>
        <input type="text" title="" id="schUser" name="schUser"
            placeholder="Change User ID / Name" class="w100p" />
      </td>
     </tr>
     <tr>
      <th scope="row">Serial No.</th>
      <td>
        <input type="text" title="" id="serialNo" name="serialNo"
            placeholder="Serial No" class="w100p" />
      </td>
      <th scope="row">Ref Doc No.</th>
      <td>
        <input type="text" title="" id="refDocNo" name="refDocNo" value="${refDocNo}"
            placeholder="Ref Doc No." class="w100p" />
      </td>
      <th scope="row">Order No.</th>
      <td>
        <input type="text" title="" id="ordNo" name="ordNo" value="${ordNo}"
            placeholder="Order No." class="w100p" />
      </td>
     </tr>
</tbody>
<input id="userBranchId" name="userBranchId" type="hidden" value="" />
</table><!-- table end -->
</form>

<ul class="right_btns mt20">
    <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="ord_grid" style="width:100%;" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>