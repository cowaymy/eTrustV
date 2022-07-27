<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    //AUIGrid 생성 후 반환 ID
    var myGridResID;
    var MEM_TYPE = '${SESSION_INFO.userTypeId}';

    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){

            /* if("${SESSION_INFO.memberLevel}" =="1"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

            }else  */
            	if("${SESSION_INFO.memberLevel}" =="2"){

                //$("#orgCode").val("${orgCode}");
                //$("#orgCode").attr("class", "w100p readonly");
                //$("#orgCode").attr("readonly", "readonly");

                $("#GrpCode").val("${grpCode}");
                $("#GrpCode").attr("class", "w100p readonly");
                $("#GrpCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="3"){

            	//$("#orgCode").val("${orgCode}");
                //$("#orgCode").attr("class", "w100p readonly");
                //$("#orgCode").attr("readonly", "readonly");

                $("#GrpCode").val("${grpCode}");
                $("#GrpCode").attr("class", "w100p readonly");
                $("#GrpCode").attr("readonly", "readonly");

                $("#DeptCode").val("${deptCode}");
                $("#DeptCode").attr("class", "w100p readonly");
                $("#DeptCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="4"){

            	//$("#orgCode").val("${orgCode}");
                //$("#orgCode").attr("class", "w100p readonly");
                //$("#orgCode").attr("readonly", "readonly");

                $("#GrpCode").val("${grpCode}");
                $("#GrpCode").attr("class", "w100p readonly");
                $("#GrpCode").attr("readonly", "readonly");

                $("#DeptCode").val("${deptCode}");
                $("#DeptCode").attr("class", "w100p readonly");
                $("#DeptCode").attr("readonly", "readonly");

                $("#SalesmanCode").val("${SESSION_INFO.userName}");
                $("#SalesmanCode").attr("class", "w100p readonly");
                //$("#memCode").attr("readonly", "readonly");
                //$("#memCode").hide();

            }
        }

      //AUIGrid.setSelectionMode(myGridResID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridResID, "cellDoubleClick", function(event){
            var ordId = event.item.salesOrdId;
            var ccpId = event.item.ccpId;
            var funcChange = '${PAGE_AUTH.funcChange}';

            $("#ccpId").val(event.item.ccpId);
            $("#salesOrdId").val(event.item.salesOrdId);
            Common.popupDiv("/sales/ccp/ccpEresubmitViewEditPop.do", {salesOrdId : ordId,ccpId : ccpId,funcChange:funcChange}, null, true, 'detailPop');
        });

     // 셀 더블클릭 이벤트 바인딩
        /* AUIGrid.bind(myGridResID, "cellDoubleClick", function(event){
            $("#chsBatchId").val('30');
            Common.popupDiv("/sales/ccp/ccpCHSDetailViewPop.do", {chsBatchId: '30'}, null, true, 'detailPop');
        }); */

        $("#_newBtn").click(function() {
            //Validation
            Common.popupDiv("/sales/ccp/ccpEresubmitNew.do", $("#eResubmitSearchForm").serializeJSON(), null, true, '_newPop');
        });

        $('#SalesmanCode').change(function(event) {
            var memCd = $('#SalesmanCode').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman(memCd);
            }
        });

    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var  columnLayout = [
                         {dataField : "salesOrdNo", headerText : '<spring:message code="sal.text.ordNo" />', width : "7%" , editable : false},
                         {dataField : "rRefNo", headerText : '<spring:message code="sal.title.text.resubRef" />', width : "7%" , editable : false},
                         {dataField : "rCrtDt", headerText : '<spring:message code="sal.title.text.resubDate" />', width : "7%" , editable : false},
                         {dataField : "rStus", headerText :'<spring:message code="sal.title.text.resubStatus" />', width : "7%" , editable : false},
                         {dataField : "name", headerText : '<spring:message code="sal.title.text.customerName" />', width : "12%" , editable : false},
                         {dataField : "ccpStatus", headerText : '<spring:message code="sal.title.text.ccpBrStus" />', width : "10%" , editable : false},
                         {dataField : "name2", headerText : '<spring:message code="sal.title.text.ccpBrRjtBrStus" />', width : "7%" , editable : false , visible: false},
                         {dataField : "resnDesc", headerText : '<spring:message code="sal.title.text.specialBrRem" />', width : "12%" , editable : false},
                         {dataField : "ccpRem", headerText : '<spring:message code="sal.title.text.ccpBrRem" />', width : "15%" , editable : false},
                         {dataField : "updAt", headerText : '<spring:message code="sal.title.text.lastBrUpdAtBrBy" />', width : "10%" , editable : false},
                         {dataField : "ccpId", visible : false},
                         {dataField : "salesOrdId", visible : false},
                         {dataField : "ccpStusId", visible : false},
                         {dataField : "custId", visible : false},

    ];

     // 그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
//            selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 60,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            wordWrap :  true
        };

        myGridResID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout,"", gridPros);
        //myGridResID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function fn_searchListAjax(){
        Common.ajax("GET", "/sales/ccp/ccpEresubmitList", $("#eResubmitSearchForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(myGridResID, result);
        });
    }

    function fn_eResubmitNew(){
        Common.popupDiv("/sales/ccp/ccpEresubmitNew.do", $("#eResubmitSearchForm").serializeJSON(), null, true, 'newPop');
    }



    function fn_loadOrderSalesman(memCode) {

        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memCode : memCode}, function(memInfo) {

            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
                $('#SalesmanCode').val('');
            }
            /* else {
                $('#_memCode').val(memInfo.memCode);
                $('#_memName').val(memInfo.name);            } */
        });
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = -1;
            }
        });
    };

    function fn_rawData() {
        Common.popupDiv("/sales/ccp/ezyCcpRawDataPop.do", null, null, true);
    }

    function fn_checkHistory() {

    Common.popupDiv("/sales/ccp/checkHistoryPop.do", '', null, true, 'detailHistoryPop');

    }
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>CCP</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Ezy CCP</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_eResubmitNew()">New</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <%-- <li><p class="btn_blue"><a href="#" onclick="javascript:$('#eResubmitSearchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li> --%>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="eResubmitSearchForm" name="eResubmitSearchForm" method="post">
<input id="memCode" name="hiddenTotal" type="hidden"/>
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
        <tbody>
            <tr>
                <th scope="row">Order No</th>
                <td >
                <input type="text" title="" id="OrderNo" name="OrderNo" placeholder="Order No" class="w100p" />
                </td>
                <th scope="row">SOF Ref No</th>
                <td >
                <input type="text" title="" id="SofRefNo" name="SofRefNo" placeholder="Sof Ref No" class="w100p" />
                </td>
                <th scope="row">Salesman Code</th>
                <td >
                <input type="text" title="" id="SalesmanCode" name="SalesmanCode" placeholder="Salesman Code" class="w100p" />
                </td>

            </tr>
            <tr>
                <th scope="row">eResubmit Date</th>
                <td >
                    <!-- date_set start -->
                        <div class="date_set">
                            <p><input type="text" id="eResubmitFrDate" name="eResubmitFrDate" title="From Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="eResubmitToDate" name="eResubmitToDate" title="To Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                        </div>
                   <!-- date_set end -->
                </td>
                <th scope="row">eResubmit Status</th>
                <td>
                <!-- <select class="w100p" id="cmbResubmitStatus" name="cmbResubmitStatus" > -->
                <select class="multy_select w100p" multiple="multiple" name="cmbResubmitStatus">
                    <option value="1" selected="selected"><spring:message code="sal.combo.text.active" /></option>
                    <option value="5" selected="selected"><spring:message code="sal.combo.text.approv" /></option>
                    <option value="6" selected="selected"><spring:message code="sal.combo.text.rej" /></option>
                    <option value="10" selected="selected"><spring:message code="sal.combo.text.cancelled" /></option>
                </select>
                </td>
                <th scope="row">CCP Status</th>
                <td >
                <select class="multy_select w100p" multiple="multiple" name="cmbCcpStatus">
                    <option value="1" selected="selected"><spring:message code="sal.combo.text.active" /></option>
                    <option value="4" selected="selected"><spring:message code="sal.combo.text.compl" /></option>
                    <option value="5" selected="selected"><spring:message code="sal.combo.text.approv" /></option>
                    <option value="6" selected="selected"><spring:message code="sal.combo.text.rej" /></option>
                    <option value="8" selected="selected"><spring:message code="sal.combo.text.inactive" /></option>
                    <option value="10" selected="selected"><spring:message code="sal.combo.text.cancelled" /></option>
                </select>
                </td>
            </tr>
            <tr>
	            <th scope="row">Dept. Code</th>
                <td >
                <input type="text" title="" id="DeptCode" name="DeptCode" placeholder="Dept Code" class="w100p" />
                </td>
                <th scope="row">Grp. code</th>
                <td >
                <input type="text" title="" id="GrpCode" name="GrpCode" placeholder="Grp Code" class="w100p" />
                </td>
                <th scope="row"></th>
                <td >
                </td>
             </tr>
        </tbody>
    </table><!-- table end -->
 <aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img
      src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
      alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt>Link</dt>
     <dd>
      <ul class="btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2">
          <a href="#" onClick="fn_rawData()">Listing</a>
         </p></li>
         <li><p class="link_btn"><a href="#" id="checkHistoryBtn" onclick="fn_checkHistory()">History</a></p></li>
      </c:if>
      </ul>
      <p class="hide_btn">
       <a href="#"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
</aside>
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->