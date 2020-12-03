<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    //AUIGrid 생성 후 반환 ID
    var myGridID;

    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            $("#loyaltyHpBatchId").val(event.item.loyaltyHpBatchId);
            Common.popupDiv("/sales/customer/loyaltyHpDetailViewPop.do", $("#loyaltyHpSearchForm").serializeJSON(), null, true, 'detailPop');
        });
    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "loyaltyHpBatchId",
                headerText : "<spring:message code='sal.title.text.batchNo' />",
                width : 130,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stusCode",
                headerText : "<spring:message code='sal.title.text.batchStus' />",
                width : 130,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "loyaltyHpTotItm",
                headerText : "Total",
                width : 130,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "loyaltyHpTotSucces",
                headerText : "Total Success",
                width : 130,
                editable : false,
                style: 'left_style',
                visible : false

            }, {
                dataField : "loyaltyHpBatchDt",
                headerText : "Batch Upload Date",
                width : 150,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "userName",
                headerText : "<spring:message code='sal.text.creator' />",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "crtDt",
                headerText : "<spring:message code='sal.text.createDate' />",
                width : 130,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }];

     // 그리드 속성 설정
        var gridPros = {

            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,

            groupingMessage : "Here grouping"
        };

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function fn_searchLoyaltyHpListAjax(){
        Common.ajax("GET", "/sales/customer/selectLoyaltyHpMstList", $("#loyaltyHpSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_loyaltyHpUpload(){
        Common.popupDiv("/sales/customer/loyaltyHpUploadPop.do", $("#loyaltyHpSearchForm").serializeJSON(), null, true, 'savePop');
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
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Loyalty HP Program</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_loyaltyHpUpload()">Upload</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchLoyaltyHpListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#loyaltyHpSearchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="loyaltyHpSearchForm" name="loyaltyHpSearchForm" method="post">
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
                <th scope="row">Batch No</th>
                <td >
                <input type="text" title="" id="loyaltyHpBatchId" name="loyaltyHpBatchId" placeholder="Loyalty HP Batch Number" class="w100p" />
                </td>
                <th scope="row"><spring:message code="sal.text.createDate" /></th>
                <td>
                <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" id="loyaltyHpCreateStDate" name="loyaltyHpCreateStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                <span>To</span>
                <p><input type="text" id="loyaltyHpCreateEnDate" name="loyaltyHpCreateEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                </div><!-- date_set end -->
                </td>
                 <th scope="row"><spring:message code="sal.text.creator" /></th>
                <td>
                <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Upload (Username)" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
                <td>
                <select class="w100p" id="cmbBatchStatus" name="cmbBatchStatus" >
                    <option value="1" ><spring:message code="sal.combo.text.active" /></option>
                    <option value="4" selected><spring:message code="sal.combo.text.compl" /></option>
                    <option value="8"><spring:message code="sal.combo.text.inactive" /></option>
                </select>
                </td>

            </tr>

        </tbody>
    </table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <%-- <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_rawData()"><spring:message code="sal.btn.conversionRawData" /></a></p></li>
        </c:if>
    </ul> --%>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->