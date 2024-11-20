<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
  //AUIGrid 생성 후 반환 ID
  var  gridID;
  $(document).ready(function(){
    $("#table1").hide();
    if("${SESSION_INFO.userTypeId}" == "1" ||"${SESSION_INFO.userTypeId}" == "2" ){
      $("#table1").show();
    }

    if ("${SESSION_INFO.memberLevel}" =="1") {
      $("#orgCode").val("${orgCode}");
      $("#orgCode").attr("class", "w100p readonly");
      $("#orgCode").attr("readonly", "readonly");
    } else if ("${SESSION_INFO.memberLevel}" =="2") {
      $("#orgCode").val("${orgCode}");
      $("#orgCode").attr("class", "w100p readonly");
      $("#orgCode").attr("readonly", "readonly");

      $("#grpCode").val("${grpCode}");
      $("#grpCode").attr("class", "w100p readonly");
      $("#grpCode").attr("readonly", "readonly");
    } else if ("${SESSION_INFO.memberLevel}" =="3") {
      $("#orgCode").val("${orgCode}");
      $("#orgCode").attr("class", "w100p readonly");
      $("#orgCode").attr("readonly", "readonly");

      $("#grpCode").val("${grpCode}");
      $("#grpCode").attr("class", "w100p readonly");
      $("#grpCode").attr("readonly", "readonly");

      $("#deptCode").val("${deptCode}");
      $("#deptCode").attr("class", "w100p readonly");
      $("#deptCode").attr("readonly", "readonly");

    } else if ("${SESSION_INFO.memberLevel}" =="4") {
      $("#orgCode").val("${orgCode}");
      $("#orgCode").attr("class", "w100p readonly");
      $("#orgCode").attr("readonly", "readonly");

      $("#grpCode").val("${grpCode}");
      $("#grpCode").attr("class", "w100p readonly");
      $("#grpCode").attr("readonly", "readonly");

      $("#deptCode").val("${deptCode}");
      $("#deptCode").attr("class", "w100p readonly");
      $("#deptCode").attr("readonly", "readonly");

      $("#memCode").val("${memCode}");
      $("#memCode").attr("class", "w100p readonly");
      $("#memCode").attr("readonly", "readonly");
    }
    
    var roleId = '${SESSION_INFO.roleId}';
    if(roleId == 256){
        $("#userBranchId").val('${SESSION_INFO.userBranchId}');
    }

    var optionUnit = { id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
                               name: "codeName",  // 콤보박스 text 에 지정할 필드명.
                               isShowChoose: false,
                               type : 'M'
    };

    CommonCombo.make('MBRSH_STUS_ID', "/status/selectStatusCategoryCdList.do", {selCategoryId : 23} , "" , optionUnit);

    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
      // fn_setDetail(listMyGridID, event.rowIndex);

      $("#ORD_ID").val(event.item.ordId);
      $("#MBRSH_ID").val(event.item.mbrshId);
      Common.popupDiv("/sales/membership/selMembershipView.do", {ORD_ID :event.item.ordId ,MBRSH_ID: event.item.mbrshId, ACTION: "VIEW" }, null, null,"membershipDtlDiv" );
    });

    f_multiCombo();

    fn_keyEvent();
  });

  // 리스트 조회.
  function fn_selectListAjax() {
    if ($("#MBRSH_NO").val() ==""  &&  $("#ORD_NO").val() =="" && $("#REF_NO").val() == "" ) {
      if (FormUtil.isEmpty($('#MBRSH_CRT_DT').val()) || FormUtil.isEmpty($('#MBRSH_END_DT').val())) {
        Common.alert("<spring:message code="sal.alert.msg.keyInMemNoOrdNoCrtDt" />");
        return ;
      } else {
         var diffDay = fn_diffDate($('#MBRSH_CRT_DT').val(), $('#MBRSH_END_DT').val());
         if(diffDay > 31|| diffDay < 0) {
           Common.alert("Please enter search period within ONE(1) months.");
           return;
         }
      }
    }

    Common.ajax("GET", "/sales/membership/selectMembershipList", $("#listSForm").serialize(), function(result) {
       AUIGrid.setGridData(gridID, result);
     });
  }

  function fn_diffDate(startDt, endDt) {
    var arrDt1 = startDt.split("/");
    var arrDt2 = endDt.split("/");

    var dt1 = new Date(arrDt1[2], arrDt1[1]-1, arrDt1[0]);
    var dt2 = new Date(arrDt2[2], arrDt2[1]-1, arrDt2[0]);

    var diff = new Date(dt2 - dt1);
    var day = diff/1000/60/60/24;

    return day;
  }

  // 조회조건 combo box
  function f_multiCombo(){
    $(function() {
      $('#MBRSH_STUS_ID').change(function() {
      }).multipleSelect({
         selectAll: true, // 전체선택
         width: '80%'
       });
       $('#MBRSH_STUS_ID').multipleSelect("checkAll");
     });
  }

  function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
               {     dataField : "mbrshNo",     headerText  : "<spring:message code="sal.title.mbrshNo" />",   width          : 100,   editable       : false},
               {     dataField : "mbrshOtstnd",   headerText  : "<spring:message code="sal.title.outstanding" />",  width          : 95,    editable       : false},
               {     dataField : "ordNo",   headerText  : "<spring:message code="sal.title.ordNo" />",     width          : 75,  editable       : false},
               {     dataField : "custName",     headerText  : "<spring:message code="sal.title.custName" />",      width          : 150,    editable       : false},
               {     dataField : "mbrshStusCode",    headerText   : "<spring:message code="sal.title.status" />",    width           : 55,    editable        : false},
               {     dataField : "mbrshStartDt", headerText  : "<spring:message code="sal.title.stDate" />",  width       : 90,  editable    : false, dataType : "date", formatString : "dd/mm/yyyy"},
               {     dataField : "mbrshExprDt",  headerText  : "<spring:message code="sal.title.expireDate" />",   width       : 90,    editable    : false, dataType : "date", formatString : "dd/mm/yyyy"},
               {     dataField : "pacName",  headerText  : "<spring:message code="sal.title.package" />",  width       : 150, editable    : false},
               {     dataField : "mbrshDur", headerText  : "<spring:message code="sal.title.durationMth" />", width       : 75,   editable    : false},
               {     dataField : "refNo", headerText  : "<spring:message code="sal.text.refNo" />", width       : 150,   editable    : false},
               {     dataField : "mbrshCrtDt",  headerText  : "<spring:message code="sal.title.crtDate" />",  width       : 90,  editable    : false,dataType : "date", formatString : "dd/mm/yyyy"},
               {     dataField : "mbrshCrtUserId",  headerText  : "<spring:message code="sal.title.creator" />", width       : 100, editable    : false},
               {     dataField : "mbrshId", visible : false },
               {     dataField : "ordId",visible : false}
    ];

    //그리드 속성 설정
    var gridPros = { usePaging           : true,             //페이징 사용
                            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                            editable                              : false,
                            fixedColumnCount    : 1,
                            showStateColumn     : true,
                            displayTreeOpen     : false,
                            //selectionMode       : "singleRow",  //"multipleCells",
                            headerHeight        : 30,
                            useGroupingPanel    : false,        //그룹핑 패널 사용
                            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                            showRowNumColumn    : true         //줄번호 칼럼 렌더러 출력
    };

    gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
  }

  function fn_doViewLegder(){
    var selectedItems = AUIGrid.getSelectedItems(gridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code="sal.alert.noMembershipSelect" /> ");
      return;
    }
    Common.popupDiv("/sales/membership/selMembershipViewLeader.do?MBRSH_ID="+selectedItems[0].item.mbrshId, null, null , true, '_ViewLegder');
  }

  // Added Edit function by Hui Ding, 2021-02-17
  function fn_doEdit() {
    var selectedItems = AUIGrid.getSelectedItems(gridID);

    if (selectedItems =="") {
      Common.alert("<spring:message code="sal.alert.msg.noMembershipSelect" />");
      return ;
    }

    // Temporary removed by Hui Ding - wait until Billing enhancement complete. 2021-05-05
    /* if (selectedItems[0].item.mbrshStusCode == 'ACT'){
          var pram  ="?MBRSH_ID="+selectedItems[0].item.mbrshId+"&ORD_ID="+selectedItems[0].item.ordId + "&ACTION=EDIT";
          Common.popupDiv("/sales/membership/selMembershipView.do"+pram, null, null, true, 'membershipDtlDiv');
        } else {
          Common.alert("Edit only applicable to ACT status membership.");
          return ;
        } */

    var pram  ="?MBRSH_ID="+selectedItems[0].item.mbrshId+"&ORD_ID="+selectedItems[0].item.ordId + "&ACTION=EDIT";
    Common.popupDiv("/sales/membership/selMembershipView.do"+pram, null, null, true, 'membershipDtlDiv');
  }

  function  fn_doMFree(){
    var _option = { width : "1200px", height : "800px" };

    //var selectedItems = AUIGrid.getSelectedItems(gridID);
    //
    // if(selectedItems.length <= 0) {
      // Common.alert(" No membership  selected. ");
      // return;
    // }
    //Common.popupWin("listSForm", "/sales/membership/membershipFreePop.do" ,_option);
    Common.popupDiv("/sales/membership/membershipFreePop.do" , {pdpaMonth:${PAGE_AUTH.pdpaMonth}}, null , true, '_FreeMembership');

     // Common.popupWin("listSForm", "/sales/membership/membershipFreePop.do?MBRSH_ID="+selectedItems[0].item.mbrshId, _option);
  }

  function  fn_doMOutSPay(){
    var selectedItems = AUIGrid.getSelectedItems(gridID);
    if (selectedItems =="") {
      Common.alert("<spring:message code="sal.alert.msg.noMembershipSelect" />");
      return ;
    }

    var v_mbrshOtstnd =selectedItems[0].item.mbrshOtstnd;
    if (parseInt(v_mbrshOtstnd,10) <= 0) {
      Common.alert("<b>[" + selectedItems[0].item.mbrshNo+ "] <spring:message code="sal.alert.msg.notHasOut" /></b>");
      return ;
    }

     var pram  ="?MBRSH_ID="+selectedItems[0].item.mbrshId+"&ORD_ID="+selectedItems[0].item.ordId;
     Common.popupDiv("/sales/membership/membershipPayment.do"+pram);
  }

  function fn_report(type) {
    /*
    var selectedItems = AUIGrid.getSelectedItems(gridID);
    if(selectedItems ==""){
      Common.alert("No membership selected..");
      return ;
    } else {
      if (type=="Invoice") {
        if (parseInt(selectedItems[0].item.mbrshId ,10) < 490447){
          // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
          var option = {
            isProcedure : false // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
          };

          $("#V_REFNO").val(selectedItems[0].item.mbrshId);
          //Common.report("reportInvoiceForm", option); */
          Common.popupDiv("/payment/initTaxInvoiceMembershipPop.do");

          /*  } else {
                 Common.alert("<b>[" + selectedItems[0].item.mbrshId+ "]  does not  has event [490447]</b>");
                  return ;
               }
            }
          }    */
  }

  function fn_keyInList(){
    Common.popupDiv("/sales/membership/membershipOutrightKeyInListPop.do" ,null, null , true , '_rptDiv1');
  }

  function fn_YSListing(){
    Common.popupDiv("/sales/membership/membershipOutrightYSListingPop.do", null, null, true);
  }

  function fn_expireList(){
    Common.popupDiv("/sales/membership/membershipOutrightExpireListPop.do", null, null, true);
  }

  function fn_expireListRental(){
    Common.popupDiv("/sales/membership/membershipOutrightExpireYearListPop.do", null, null, true);
  }

  function fn_keyEvent(){
    $("#MBRSH_NO").keydown(function(key)  {
      if (key.keyCode == 13) {
        fn_selectListAjax();
      }
    });
  }

  function fn_clear(){
    $("#MBRSH_NO").val("");
    $("#ORD_NO").val("");
    $("#MBRSH_CRT_DT").val("");
    $("#MBRSH_CRT_USER_ID").val("");
    $("#MBRSH_OTSTND").val("");
    $("text").each(function(){
      if($(this).hasClass("readonly")){
      }else{
        $(this).val("");
      }
    });
    $("#MBRSH_STUS_ID").multipleSelect("uncheckAll");
  }

</script>

<form id="popForm" method="post">
  <input type="hidden" name="ORD_ID"  id="ORD_ID"/>
  <input type="hidden" name="MBRSH_ID"   id="MBRSH_ID"/>
</form>

<form id="reportInvoiceForm" method="post">
  <input type="hidden" id="reportFileName" name="reportFileName" value="/membership/MembershipInvoice.rpt" />
  <input type="hidden" id="viewType" name="viewType" value="PDF" />
  <input type="hidden" id="V_REFNO" name="V_REFNO"  value=""/>
</form>

<section id="content"><!-- content start -->
<ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.membershipOutright" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    <li>
      <p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_doEdit();"><spring:message code="sales.btn.edit" /></a></p>
    </li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li>
      <p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_doMFree();"><spring:message code="sal.btn.freeMembership" /></a></p>
    </li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li>
      <p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p>
    </li>
    </c:if>
  <li>
    <p class="btn_blue"><a href="#" onclick="javascript:fn_clear()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p>
  </li>
</ul>
</aside>
<!-- title_line end -->

<section class="search_table">
  <!-- search_table start -->
  <form action="#"  id="listSForm" name="listSForm" method="post">
	<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${PAGE_AUTH.pdpaMonth}'/>
	<input id="userBranchId" name="userBranchId" type="hidden" value="" />
    <table class="type1">
    <!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
      <tr>
        <th scope="row"><spring:message code="sal.text.membershipNo" /><span class="must">*</span></th>
        <td>
           <input type="text" title="" id="MBRSH_NO" name="MBRSH_NO"placeholder="Membership Number" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.text.ordNo" /><span class="must">*</span></th>
        <td>
          <input type="text" title=""  id="ORD_NO"  name="ORD_NO" placeholder="Order Number" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.text.createDate" /><span class="must">*</span></th>
        <td>
          <div class="date_set w100p"><!-- date_set start -->
            <p><input id="MBRSH_CRT_DT" name="MBRSH_CRT_DT" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
            <span>To</span>
            <p><input id="MBRSH_END_DT" name="MBRSH_END_DT" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
          </div><!-- date_set end -->
        </td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="sal.text.createBy" /></th>
        <td>
          <input type="text" title=""  id="MBRSH_CRT_USER_ID"  name="MBRSH_CRT_USER_ID" placeholder="Creator" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.text.status" /></th>
        <td>
          <select id="MBRSH_STUS_ID" name="MBRSH_STUS_ID" class="multy_select w100p" multiple="multiple" ></select>
        </td>
        <th scope="row"><spring:message code="sal.title.outstanding" /></th>
        <td>
          <select class="w100p"  id="MBRSH_OTSTND" name="MBRSH_OTSTND" >
            <option value=""> </option>
            <option value="1"><spring:message code="sal.combo.text.withOutstanding" /></option>
            <option value="2"><spring:message code="sal.combo.text.withoutOutstanding" /></option>
            <option value="3"><spring:message code="sal.combo.text.overPaid" /></option>
          </select>
        </td>
      </tr>

      <!-- Added Reference No criteria by Hui Ding, 2021-08-11 -->
      <tr>
        <th scope="row"><spring:message code="sal.text.refNo" /><span class="must">*</span></th>
        <td>
          <input type="text" title=""  id="REF_NO"  name="REF_NO" placeholder="Reference No." class="w100p" />
        </td>
        <th></th><td></td>
        <th></th><td></td>
      </tr>
      <tr>
        <th scope="row" colspan="6" ><span class="must"> <spring:message code="sal.alert.msg.keyInMemNoOrdNoCrtDt" /></span>  </th>
      </tr>
    </tbody>
  </table><!-- table end -->

  <table class="type1"  id="table1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
      <col style="width:140px" />
       <col style="width:*" />
      <col style="width:140px" />
      <col style="width:*" />
      <col style="width:140px" />
      <col style="width:*" />
      <col style="width:140px" />
      <col style="width:*" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row"><spring:message code="sal.text.orgCode" /></th>
        <td>
           <input type="text" title="" id="orgCode" name="orgCode" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.text.grpCode" /></th>
        <td>
          <input type="text" title=""  id="grpCode"  name="grpCode" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.text.detpCode" /></th>
        <td>
          <input type="text" title=""   id="deptCode" name="deptCode" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.text.memberCode" /></th>
        <td>
          <input type="text" title=""   id="memCode" name="memCode" class="w100p" />
        </td>
      </tr>
    </tbody>
  </table>
  <!-- table end -->

  <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
      <dt>Link</dt>
      <dd>
        <ul class="btns">
          <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="link_btn"><a href="#" onclick="javascript: fn_doViewLegder()"> <spring:message code="sal.btn.link.ledger" /></a></p></li>
          </c:if>
          <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="link_btn type2"><a href="#" onclick="javascript: fn_report('Invoice')"><spring:message code="sal.btn.link.invoice" /></a></p></li>
          </c:if>
          <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' && SESSION_INFO.userTypeId != '2'}">
            <li><p class="link_btn type2"><a href="#" onclick="javascript: fn_keyInList()" ><spring:message code="sal.btn.link.keyInList" /></a></p></li>
          </c:if>
          <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' && SESSION_INFO.userTypeId != '2'}">
            <li><p class="link_btn type2"><a href="#" onclick="javascript: fn_YSListing()"><spring:message code="sal.btn.link.ysList" /></a></p></li>
          </c:if>
          <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="link_btn type2"><a href="#" onclick="javascript: fn_expireList()"><spring:message code="sal.btn.link.expireList" /></a></p></li>
          </c:if>
          <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
            <li><p class="link_btn type2"><a href="#" onclick="javascript: fn_expireListRental()"><spring:message code="sal.btn.link.expireListYear" /></a></p></li>
          </c:if>
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
      </dd>
    </dl>
  </aside><!-- link_btns_wrap end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<!--
<ul class="right_btns">
  <li><p class="btn_grid"><a href="#" onclick="javascript: fn_expireList()">Expire List</a></p></li>
  <li><p class="btn_grid"><a href="#" onclick="javascript: fn_expireListRental()">Expire List (Only Rental)</a></p></li>
</ul>
 -->

<article class="grid_wrap"><!-- grid_wrap start -->
  <div id="list_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->

