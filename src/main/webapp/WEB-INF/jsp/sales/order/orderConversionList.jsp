<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
	//AUIGrid 생성 후 반환 ID
	var myGridID;

	$(document).ready(function(){

		// AUIGrid 그리드를 생성합니다.
        createAUIGrid();

      //AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            $("#rsCnvrId").val(event.item.rsCnvrId);
            Common.popupDiv("/sales/order/conversionDetailPop.do", $("#searchForm").serializeJSON(), null, true, 'detailPop');
        });
	});

	function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "rsCnvrNo",
                headerText : "<spring:message code='sal.title.text.batchNo' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "code",
                headerText : "<spring:message code='sal.title.text.batchStus' />",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrStusFrom",
                headerText : "<spring:message code='sal.title.text.statusFrom' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrStusTo",
                headerText : "<spring:message code='sal.title.text.statusTo' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "code1",
                headerText : "<spring:message code='sal.title.text.convertStatus' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrDt",
                headerText : "<spring:message code='sal.title.text.convertDate' />",
                width : 110,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrCrtUserName",
                headerText : "<spring:message code='sal.text.creator' />",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrCrtDt",
                headerText : "<spring:message code='sal.text.createDate' />",
                width : 110,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrCnfmUserName",
                headerText : "<spring:message code='sal.title.text.confirmBy' />",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrCnfmDt",
                headerText : "<spring:message code='sal.title.text.confirmDate' />",
                width : 110,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            },{
                dataField : "rsCnvrId",
                visible : false
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

            groupingMessage : "Here groupping"
        };

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

	function fn_searchListAjax(){
        Common.ajax("GET", "/sales/order/orderConversionJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

	function fn_newConvert(){
        Common.popupDiv("/sales/order/orderConvertNewPop.do", $("#detailForm").serializeJSON(), null, true, 'savePop');
    }

	function fn_rawData(){
		Common.popupDiv("/sales/order/orderConversionRawDataPop.do", null, null, true);
    }

	function fn_summaryReport(){
	        Common.popupDiv("/sales/order/orderConversionSummaryReportPop.do", null, null, true);
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
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.conversionList" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_newConvert()"><spring:message code="sal.btn.new" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="rsCnvrId" name="rsCnvrId">
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
			    <th scope="row"><spring:message code="sal.text.conversionNo" /></th>
			    <td colspan="3">
			    <input type="text" title="" id="convNo" name="convNo" placeholder="Conversion Number" class="w100p" />
			    </td>
			    <th scope="row"><spring:message code="sal.text.createDate" /></th>
			    <td>
			    <div class="date_set w100p"><!-- date_set start -->
			    <p><input type="text" id="createStDate" name="createStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
			    <span>To</span>
			    <p><input type="text" id="createEnDate" name="createEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
			    </div><!-- date_set end -->
			    </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
			    <td>
			    <select class="multy_select w100p" id="cmbBatchStatus" name="cmbBatchStatus" multiple="multiple">
			        <option value="1" selected><spring:message code="sal.combo.text.active" /></option>
			        <option value="4"><spring:message code="sal.combo.text.compl" /></option>
			        <option value="8"><spring:message code="sal.combo.text.inactive" /></option>
			    </select>
			    </td>
			    <th scope="row"><spring:message code="sal.title.text.convertStatus" /></th>
			    <td>
			    <select class="multy_select w100p" id="cmbConvStatus" name="cmbConvStatus" multiple="multiple">
			        <option value="44" selected><spring:message code="sal.text.pending" /></option>
			        <option value="4"><spring:message code="sal.combo.text.compl" /></option>
			    </select>
			    </td>
			    <th scope="row"><spring:message code="sal.text.creator" /></th>
			    <td>
			    <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Conversion (Username)" class="w100p" />
			    </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code="sal.title.text.statusFrom" /></th>
			    <td>
			    <select class="multy_select w100p" id="cmbStatusFr" name="cmbStatusFr" multiple="multiple">
			        <option value="REG"><spring:message code="sal.combo.text.regular" /></option>
			        <option value="INV"><spring:message code="sal.combo.text.investigate" /></option>
			        <option value="SUS"><spring:message code="sal.combo.text.supend" /></option>
			        <option value="RET"><spring:message code="sal.combo.text.returned" /></option>
			        <option value="TER"><spring:message code="sal.combo.text.terminated" /></option>
			    </select>
			    </td>
			    <th scope="row"><spring:message code="sal.title.text.statusTo" /></th>
			    <td>
			    <select class="multy_select w100p" id="cmbStatusTo" name="cmbStatusTo" multiple="multiple">
			        <option value="REG"><spring:message code="sal.combo.text.regular" /></option>
			        <option value="INV"><spring:message code="sal.combo.text.investigate" /></option>
			        <option value="SUS"><spring:message code="sal.combo.text.supend" /></option>
			        <option value="RET"><spring:message code="sal.combo.text.returned" /></option>
			        <option value="TER"><spring:message code="sal.combo.text.terminated" /></option>
			    </select>
			    </td>
			    <th scope="row"><spring:message code="sal.text.confirmAt" /></th>
			    <td>
			    <div class="date_set w100p"><!-- date_set start -->
			    <p><input type="text" id="stConvConfDt" name="stConvConfDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
			    <span><spring:message code="sal.text.to" /></span>
			    <p><input type="text" id="endConvConfDt" name="endConvConfDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
			    </div><!-- date_set end -->
			    </td>
			</tr>
			<tr>
			    <th scope="row"><spring:message code="sal.text.remark" /></th>
			    <td colspan="3">
			    <input type="text" title="" id="convRem" name="convRem" placeholder="Customer ID(Number Only)" class="w100p" />
			    </td>
			    <th scope="row"><spring:message code="sal.title.text.confirmBy" /></th>
			    <td>
			    <input type="text" title="" id="confUser" name="confUser" placeholder="Customer Name" class="w100p" />
			    </td>
			</tr>
		</tbody>
	</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_rawData()"><spring:message code="sal.btn.conversionRawData" /></a></p></li>
        <li><p class="link_btn type2"><a href="#" onClick="fn_summaryReport()"><spring:message code="sal.btn.summaryReport" /></a></p></li>
        </c:if>
    </ul>
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