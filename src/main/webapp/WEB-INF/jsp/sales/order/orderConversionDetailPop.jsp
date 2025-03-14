<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var itemGridID;

	$(document).ready(function(){


	    // AUIGrid 그리드를 생성합니다.
	    createAUIitemGrid();

	    fn_getCnvrItmJsonAjax();

	    $('#excelDown').click(function() {
	           GridCommon.exportTo("dt_grid_wrap", 'xlsx', "Conversion List");
	        });

	});

	function createAUIitemGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "rsItmOrdNo",
                headerText : "<spring:message code='sal.text.ordNo' />",
                width : 90,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "code1",
                headerText : "<spring:message code='sal.text.status' />",
                width : 70,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsSysAppTypeCode",
                headerText : "<spring:message code='sal.title.text.appType' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsSysRentalStus",
                headerText : "<spring:message code='sal.text.rentalStatus' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsItmCrtUserName",
                headerText : "<spring:message code='sal.text.creator' />",
                width : 120,
                editable : false,
                style: 'left_style'
            },{
                dataField : "rsItmCrtDt",
                headerText : "<spring:message code='sal.text.createDate' />",
                width : 100,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            },{
                dataField : "rsItmValidRem",
                headerText : "<spring:message code='sal.text.remark' />",
                editable : false,
                style: 'left_style'
            },{
            	dataField : "undefined",
                headerText : "Edit",
                width : 110,
                renderer : {
                      type : "ButtonRenderer",
                      labelText : "Remove",
                      onclick : function(rowIndex, columnIndex, value, item) {
                    	  $("#rsItmId").val(item.rsItmId);
                    	  Common.ajax("GET", "/sales/order/orderConvertItmRemove.do",$("#gridForm").serialize(), function(result) {
                    		  Common.alert("The item has been removed.", fn_success);
                          });
                      }
               }
            }];

        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : false,
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
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };

        itemGridID = AUIGrid.create("#dt_grid_wrap", columnLayout, gridPros);
    }

	//Get Contact by Ajax
    function fn_getCnvrItmJsonAjax(){
        Common.ajax("GET", "/sales/order/orderConvertViewItmJsonList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
    }

	function fn_all(){
		Common.ajax("GET", "/sales/order/orderConvertViewItmJsonList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
	}

	function fn_valid(){
        Common.ajax("GET", "/sales/order/orderCnvrValidItmList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
    }

	function fn_invalid(){
        Common.ajax("GET", "/sales/order/orderCnvrInvalidItmJsonList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
    }

	function fn_success(){
		$("#_close").click();
		fn_searchListAjax();
		Common.popupDiv("/sales/order/conversionDetailPop.do", $("#searchForm").serializeJSON(), null, true, 'detailPop');
	}

	function fn_confirm(){
		var time = new Date();
		var day = time.getDate();

//		if( (day >= 26 || day == 1) && ($("#rsCnvrStusFrom").val() == 'REG') && ($("#rsCnvrStusTo").val() == 'INV')){
//		    Common.alert("This coversion type is not allowed from 26 until 1 next month.");
//		    return false;
//		}else{
//			if($("#allRows").val() <= 0){
//				Common.alert("<b>There are no item to convert in this conversion batch.<br />Confirm conversion batch is disallowed.");
//				return false;
//			}
//		}
		var msg = "<b><spring:message code='sal.alert.msg.thisConversionBatchWillProcess' /><br />";
		     msg += "<spring:message code='sal.alert.msg.areYouSureWantToConfirmConvtBatch' /></b>";
		Common.confirm(msg,fn_confirmOK);
	}

	function fn_confirmOK(){
		Common.ajax("GET", "/sales/order/updCnvrConfirm.do", $("#gridForm").serialize(), function(result){
            Common.alert("<spring:message code='sal.alert.msg.conversionConfirmed' />", fn_success);
        });
	}

	function fn_deactivate(){
		var msg = ("<b><spring:message code='sal.alert.msg.deactivateConversionBatch' /></b>");
		Common.confirm(msg,fn_deactivateOK);

    }

	function fn_deactivateOK(){
        Common.ajax("GET", "/sales/order/updCnvrDeactive.do", $("#gridForm").serialize(), function(result){
            Common.alert("<b><spring:message code='sal.alert.msg.conversionBatchDeactivated' /></b>", fn_success);
        });
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.conversionViewConfirm" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.page.title.conversionBatchInfo" /></h3>
<c:if test="${cnvrInfo.code eq 'ACT'}">
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="fn_confirm()"><spring:message code="sal.btn.confirm" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="fn_deactivate()"><spring:message code="sal.btn.deactivate" /></a></p></li>
</ul>
</c:if>
</aside><!-- title_line end -->

<form id="gridForm" name="gridForm" method="GET">
    <input type="hidden" id="validChk" name="validChk">
    <input type="hidden" id="invalidChk" name="invalidChk">
    <input type="hidden" id="rsItmId" name="rsItmId">
    <input type="hidden" id="rsCnvrId" name="rsCnvrId" value="${cnvrInfo.rsCnvrId}">
    <input type="hidden" id="validRows" name="validRows" value="${validRows }">
    <input type="hidden" id="invalidRows" name="invalidRows" value="${invalidRows }">
    <input type="hidden" id="allRows" name="allRows" value="${allRows }">
    <input type="hidden" id="rsCnvrStusFrom" name="rsCnvrStusFrom" value="${cnvrInfo.rsCnvrStusFrom }">
    <input type="hidden" id="rsCnvrStusTo" name="rsCnvrStusTo" value="${cnvrInfo.rsCnvrStusTo }">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.convertNo" /></th>
    <td><span>${cnvrInfo.rsCnvrNo }</span></td>
    <th scope="row"><spring:message code="sal.text.createAt" /></th>
    <td><span>${cnvrInfo.rsCnvrCrtDt }</span></td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><span>${cnvrInfo.rsCnvrCrtUserName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
    <td><span>${cnvrInfo.name }</span></td>
    <th scope="row"><spring:message code="sal.title.text.statusFrom" /></th>
    <td><span>${cnvrInfo.rsCnvrStusFrom }</span></td>
    <th scope="row"><spring:message code="sal.title.text.statusTo" /></th>
    <td><span>${cnvrInfo.rsCnvrStusTo }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.reactiveFeesApply" /></th>
    <td><span>
        <c:choose >
             <c:when test="${cnvrInfo.rsCnvrReactFeesApply eq 1 }">
                 Yes
             </c:when>
             <c:otherwise>
                 No
             </c:otherwise>
         </c:choose>
       </span>
    </td>
    <th scope="row"><spring:message code="sal.text.confirmAt" /></th>
    <td>
        <span>
            <c:choose >
                <c:when test="${cnvrInfo.rsCnvrCnfmDt eq '01-01-1900'}">
                -
                </c:when>
                <c:otherwise>
                ${cnvrInfo.rsCnvrCnfmDt }
                </c:otherwise>
            </c:choose>
        </span>
    </td>
    <th scope="row"><spring:message code="sal.title.text.confirmBy" /></th>
    <td><span>${cnvrInfo.rsCnvrCnfmUserName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.convertStatus" /></th>
    <td><span>${cnvrInfo.name }</span></td>
    <th scope="row"><spring:message code="sal.text.convertAt" /></th>
    <td>
        <span>
            <c:choose >
                <c:when test="${cnvrInfo.rsCnvrDt eq '01-01-1900'}">
                -
                </c:when>
                <c:otherwise>
                ${cnvrInfo.rsCnvrDt }
                </c:otherwise>
            </c:choose>
        </span>
    </td>
    <th scope="row"><spring:message code="sal.text.convertBy" /></th>
    <td><span>${cnvrInfo.rsCnvrUserName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.totItem" /></th>
    <td><span>${allRows }</span></td>
    <th scope="row"><spring:message code="sal.text.totalValidItem" /></th>
    <td><span>${validRows }</span></td>
    <th scope="row"><spring:message code="sal.text.totalInvalidItem" /></th>
    <td><span>${invalidRows }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="5"><span>${cnvrInfo.rsCnvrRem }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.batchItem" /></h3>
</aside><!-- title_line end -->

<ul class="left_btns">
    <li><p class="btn_grid"><a href="#" onclick="fn_all()"><spring:message code="sal.combo.text.allItm" /></a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="fn_valid()"><spring:message code="sal.combo.text.validItm" /></a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="fn_invalid()"><spring:message code="sal.combo.text.invalidItm" /></a></p></li>
    <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code="Generate Listing"/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end-->

