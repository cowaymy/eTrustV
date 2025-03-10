<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


    //AUIGrid 생성 후 반환 ID
    var listMyGridID;
    var IS_3RD_PARTY = '${SESSION_INFO.userIsExternal}';
    var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

    var _option = {
        width : "1200px", // 창 가로 크기 
        height : "800px" // 창 세로 크기
    };

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        if("${SESSION_INFO.userTypeId}" != "4" && "${SESSION_INFO.userTypeId}" != "6") {
            $("#orgCode").attr("readonly", true);
            $("#grpCode").attr("readonly", true);
            $("#deptCode").attr("readonly", true);
        }

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listMyGridID, "cellDoubleClick", function(event) {
            if(IS_3RD_PARTY == '0') {
                fn_setDetail(listMyGridID, event.rowIndex);
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
            }
        });

        if(IS_3RD_PARTY == '0') {
            doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'listAppType', 'M', 'fn_multiCombo2'); //Common Code
        }
        doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'EXHC'}, '', 'listProductId', 'S', 'fn_setOptGrpClass');//product 생성

        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code

        doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : 5, parmDisab : 0}, '', 'listRentStus', 'M', 'fn_multiCombo');
        doGetComboData('/common/selectStoreList.do', '', '', 'storeCodeId', 'M', 'fn_multiCombo2');
    });

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text");
    }

    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
        Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null, true, "_divIdOrdDtl");
    }

    // 리스트 조회.
    /* no Hazelcast use below */
    function fn_selectListAjax() {

        //if(IS_3RD_PARTY == '1') $("#listAppType").removeAttr("disabled");

        Common.ajax("GET", "/sales/cwStore/selectCwStoreOrderJsonList.do", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listMyGridID, result);
        });

        //if(IS_3RD_PARTY == '1') $("#listAppType").prop("disabled", true);
    }

    $(function(){
        $('#btnSrch').click(function() {
            /* no Hazelcast use below*/
            if(fn_validSearchList()) fn_selectListAjax();

            /* for Hazelcast use below
            if(fn_validSearchList()) fn_selectListAjax('N');*/
        });
        /* for Hazelcast use below
        $('#btnSrchHzcast').click(function() {
            if(fn_validSearchList()) fn_selectListAjax('Y');
        });*/
        $('#btnClear').click(function() {
          //  alert();
            location.reload();
            //alert();
            //$('#listSearchForm').clearForm();
        });
   
        $('#_btnLedger1').click(function() {
            var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];

            if(selIdx > -1) {
                $('#_ordId').val(AUIGrid.getCellValue(listMyGridID, selIdx, "ordId"));
                Common.popupWin("_frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
            }
        });
        $('#_btnLedger2').click(function() {
            var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];

            if(selIdx > -1) {
                $('#_ordId').val(AUIGrid.getCellValue(listMyGridID, selIdx, "ordId"));
                Common.popupWin("_frmLedger", "/sales/order/orderLedger2ViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
            }
        });
        $('#btnOrderRaw').click(function() {
            Common.popupDiv("/sales/cwStore/cwStoreSalesOrderRaw.do",null, null , true);
          });
    });

    function fn_validSearchList() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#listOrdNo').val())
        && FormUtil.isEmpty($('#listCustId').val())
        && FormUtil.isEmpty($('#listCustName').val())
        && FormUtil.isEmpty($('#listCustIc').val())
        && FormUtil.isEmpty($('#listVaNo').val())
        && FormUtil.isEmpty($('#listSalesmanCode').val())
        && FormUtil.isEmpty($('#listPoNo').val())
        && FormUtil.isEmpty($('#listContactNo').val())
        && FormUtil.isEmpty($('#listSerialNo').val())
        && FormUtil.isEmpty($('#listSirimNo').val())
        && FormUtil.isEmpty($('#listRelatedNo').val())
        && FormUtil.isEmpty($('#listCrtUserId').val())
        && FormUtil.isEmpty($('#listPromoCode').val())
        && FormUtil.isEmpty($('#listRefNo').val())
        ) {

            if(FormUtil.isEmpty($('#listOrdStartDt').val()) || FormUtil.isEmpty($('#listOrdEndDt').val())) {
                isValid = false;
                msg += '* <spring:message code="sal.alert.msg.selOrdDt" /><br/>';
            }
            else {
                var diffDay = fn_diffDate($('#listOrdStartDt').val(), $('#listOrdEndDt').val());

                if(diffDay > 91 || diffDay < 0) {
                    isValid = false;
                    msg += '* <spring:message code="sal.alert.msg.srchPeriodDt" />';
                }
            }
        }

        if(!isValid) Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
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

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "<spring:message code='sales.OrderNo'/>", dataField : "ordNo",       editable : false, width : 80  }
          , { headerText : "<spring:message code='sales.Status'/>",  dataField : "ordStusCode", editable : false, width : 80  }
          , { headerText : "<spring:message code='sales.AppType'/>", dataField : "appTypeCode", editable : false, width : 80  }
          , { headerText : "<spring:message code='sales.ordDt'/>",   dataField : "ordDt",       editable : false, width : 100 }
          , { headerText : "<spring:message code='sales.refNo2'/>",  dataField : "refNo",       editable : false, width : 60  }
          , { headerText : "<spring:message code='sales.prod'/>",    dataField : "productName", editable : false, width : 150 }
          , { headerText : "<spring:message code='sales.custId'/>",  dataField : "custId",      editable : false, width : 70  }
          , { headerText : "<spring:message code='sales.cusName'/>", dataField : "custName",    editable : false}
          , { headerText : "<spring:message code='sales.NRIC2'/>",   dataField : "custIc",      editable : false, width : 100 }
          , { headerText : "<spring:message code='sales.Creator'/>", dataField : "crtUserId",   editable : false, width : 100 }
          , { headerText : "<spring:message code='sales.pvYear'/>",  dataField : "pvYear",      editable : false, width : 60  }
          , { headerText : "<spring:message code='sales.pvMth'/>",   dataField : "pvMonth",     editable : false, width : 60  }
          , { headerText : "ordId",                                  dataField : "ordId",       visible  : false }
          , { headerText : "salesmanCode",                                  dataField : "salesmanCode",       visible  : false }
          , { headerText : "stkCtgryId",                                  dataField : "stkCtgryId",       visible  : false }
           ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        listMyGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
    }

    function fn_calcGst(amt) {
        var gstAmt = 0;
        if(FormUtil.isNotEmpty(amt) || amt != 0) {
            //gstAmt = Math.floor(amt*(1/1.06));
            gstAmt = Math.floor(amt*(1/1.00));
        }
        return gstAmt;
    }

    function fn_multiCombo(){
        $('#listKeyinBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listDscBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        //$('#listOrdStusId').multipleSelect("checkAll");
        $('#listRentStus').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
//      $('#listRentStus').multipleSelect("checkAll");
    }

    function fn_multiCombo2(){
        $('#listAppType').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listAppType').multipleSelect("checkAll");
        
        $('#storeCodeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#storeCodeId').multipleSelect("checkAll");
    }


    function fn_report() {
        var option = {
            isProcedure : false
        };
        Common.report("dataForm2", option);
    }


    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }
        });
    };
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code='sales.path.sales'/></li>
    <li><spring:message code='sales.path.order'/></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='sales.title.cwStoreOrderList'/></h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span><spring:message code='sales.Search'/></a></p></li>
    <li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span><spring:message code='sales.Clear'/></a></p></li>
</c:if>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<!-- Ledger Form -->

<form id="listSearchForm" name="listSearchForm" action="#" method="post">
    <input id="listSalesOrderId" name="salesOrderId" type="hidden" />
    <input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${PAGE_AUTH.pdpaMonth}'/>
<%--     <input id="memId" name="memId" type="hidden" value="${memId}"/> --%>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.OrderNo'/></th>
    <td>
    <input id="listOrdNo" name="ordNo" type="text" title="Order No" placeholder="<spring:message code='sales.OrderNo'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.AppType2'/></th>
    <td>
<c:if test="${SESSION_INFO.userIsExternal == '0'}">
    <select id="listAppType" name="appType" class="multy_select w100p" multiple="multiple"></select>
</c:if>
<c:if test="${SESSION_INFO.userIsExternal == '1'}">
    <!-- <select id="listAppType" name="appType" class="w100p" disabled></select> -->
       <select id="listAppType" name="appType">
        <option value="66">Rental</option>
        <option value="1412">Outright</option>
        </select>
</c:if>
    </td>
    <th scope="row"><spring:message code='sales.ordDt'/></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="listOrdStartDt" name="ordStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="listOrdEndDt" name="ordEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.ordStus'/></th>
    <td>
        <select id="listOrdStusId" name="ordStusId" class="multy_select w100p" multiple="multiple">
              <c:if test="${SESSION_INFO.userTypeId != '2'}">
                    <option value="1">Active</option>
               </c:if>
               <option value="4">Completed</option>
               <option value="10">Cancelled</option>
        </select>
    </td>
    <th scope="row"><spring:message code='sales.keyInBranch'/></th>
    <td>
    <select id="listKeyinBrnchId" name="keyinBrnchId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.dscBranch'/></th>
    <td>
    <select id="listDscBrnchId" name="dscBrnchId" class="multy_select w100p" multiple="multiple"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.custId2'/></th>
    <td>
    <input id="listCustId" name="custId" type="text" title="<spring:message code='sales.custId2'/>" placeholder="Customer ID (Number Only)" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.cusName'/></th>
    <td>
    <input id="listCustName" name="custName" type="text" title="Customer Name" placeholder="<spring:message code='sales.cusName'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.NRIC2'/></th>
    <td>
    <input id="listCustIc" name="custIc" type="text" title="NRIC/Company No" placeholder="<spring:message code='sales.NRIC2'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.prod'/></th>
    <td>
    <select id="listProductId" name="productId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.salesman'/></th>
    <td>
    <input id="listSalesmanCode" name="salesmanCode" type="text" title="Salesman" placeholder="<spring:message code='sales.salesman'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.RentalStatus'/></th>
    <td>
    <select id="listRentStus" name="rentStus" class="multy_select w100p" multiple="multiple"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.refNo3'/></th>
    <td>
    <input id="listRefNo" name="refNo" type="text" title="Reference No<" placeholder="<spring:message code='sales.refNo3'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.poNum'/></th>
    <td>
    <input id="listPoNo" name="poNo" type="text" title="PO No" placeholder="<spring:message code='sales.poNum'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.ContactNo'/></th>
    <td>
    <input id="listContactNo" name="contactNo" type="text" title="Contact No" placeholder="<spring:message code='sales.ContactNo'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.vaNum'/></th>
    <td>
    <input id="listVaNo" name="vaNo" type="text" title="VA Number" placeholder="<spring:message code='sales.vaNum'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.SeriacNo'/></th>
    <td>
    <input id="listSerialNo" name="serialNo" type="text" title="Serial Number" onkeyup="this.value = this.value.toUpperCase();" placeholder="<spring:message code='sales.SeriacNo'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.SirimNo'/></th>
    <td>
    <input id="listSirimNo" name="sirimNo" type="text" title="Sirim Number" onkeyup="this.value = this.value.toUpperCase();" placeholder="<spring:message code='sales.SirimNo'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.Creator'/></th>
    <td>
    <input id="listCrtUserId" name="crtUserId" type="text" title="Creator" placeholder="Creator (Username)" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.promoCd'/></th>
    <td>
    <input id="listPromoCode" name="promoCode" type="text" title="Promotion Code" placeholder="<spring:message code='sales.promoCd'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.relatedNo2'/></th>
    <td>
    <input id="listRelatedNo" name="relatedNo" type="text" title="Related No(Exchange)" placeholder="<spring:message code='sales.relatedNo2'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Org Code</th>
    <td><input type="text" title="orgCode" id="orgCode" name="orgCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Org Code" class="w100p" value="${orgCode}"/></td>
    <th scope="row">Grp Code</th>
    <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  onkeyup="this.value = this.value.toUpperCase();" placeholder="Grp Code" class="w100p" value="${grpCode}"/></td>
    <th scope="row">Dept Code</th>
    <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  onkeyup="this.value = this.value.toUpperCase();" placeholder="Dept Code" class="w100p" value="${deptCode}"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.isEKeyin'/></th>
    <td>
    <input id="isEKeyin" name="isEKeyin" type="checkbox"/>
    </td>
    <th scope="row">is e-Commerce</th>
    <td>
    <input id="isECommerce" name="isECommerce" type="checkbox"/>
    </td>
    <th scope="row">is cowayWorld</th>
    <td>
    <input id="isCwWorld" name="isCwWorld" type="checkbox"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sal.text.cwStoreCode'/></th>
    <td>
    <select id="storeCodeId" name="storeCodeId" class="multy_select w100p" multiple="multiple"/>
    </td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must"><spring:message code='sales.msg.ordlist.keyin'/></span></th>
</tr>
</tbody>
</table><!-- table end -->

</form>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
  <dt>Link</dt>
  <dd>
  <ul class="btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
      <li><p class="link_btn"><a href="#" id="btnOrderRaw"><spring:message code='sales.btn.cwStoreOrderRaw'/></a></p></li>
    </c:if>
  </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
