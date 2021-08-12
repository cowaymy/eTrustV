<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
var itemGridID;
	$(document).ready(function() {
		createAUIGrid();
		fn_itemDetailSearch('0');

		$("#clearComfirm").click(function(){
			$("#search").click();
		});
	});

	function createAUIGrid() {
        var columnLayout = [ {
            dataField : "remove",
            headerText : '',
            width: 65,
            renderer : {
                type : "CheckBoxEditRenderer",
                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "1", // true, false 인 경우가 기본
                unCheckValue : "0"
            }
        },{
            dataField : "userMemCode",
            headerText : "<spring:message code='commission.text.search.memCode'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "codeNm",
            headerText : "<spring:message code='commission.text.search.type'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "memNm",
            headerText : "<spring:message code='commission.text.grid.memberName'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "code",
            headerText : "<spring:message code='commission.text.search.status'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "validRem",
            headerText : "<spring:message code='commission.text.grid.remark'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "userCffMark",
            headerText : "<spring:message code='commission.text.grid.mark'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "uploadDetId",
            style : "my-column",
            visible : false,
            editable : false
        }];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            height : 280

        };

        itemGridID = AUIGrid.create("#grid_wrap_confirm", columnLayout,gridPros);
   }

	function fn_itemDetailSearch(val){
		if(val == "0"){
			$("#vStusId").val("");
			Common.ajax("GET", "/commission/calculation/cffItemList", $("#conForm").serializeJSON(), function(result) {
                AUIGrid.setGridData(itemGridID, result);
            });
		}else{
			$("#vStusId").val(val);
            Common.ajax("GET", "/commission/calculation/cffItemList", $("#conForm").serializeJSON(), function(result) {
                AUIGrid.setGridData(itemGridID, result);
            });
		}
	}

	function fn_itemAdd(){
		Common.popupDiv("/commission/calculation/commCFFItemAddPop.do",$("#conForm").serializeJSON());
	}

	function fn_removeItem(){
		Common.ajax("POST", "/commission/calculation/removeCFFItem.do", GridCommon.getEditData(itemGridID) , function(result) {
			Common.alert('<spring:message code="commission.alert.incentive.itemRemove"/>');
			$("#totalCntTxt").text(result.data.totalCnt);
            $("#totalValidTxt").text(result.data.totalValid);
            $("#totalInvalidTxt").text(result.data.totalInvalid);
            $("#cntValid").val(result.data.totalValid);
			fn_itemDetailSearch('0');
		});
	}

	function fn_deactivate(){
		var valTemp = {"uploadId" : $('#uploadUserId').val()};
		Common.ajax("GET", "/commission/calculation/deactivateCFFCheck", $("#conForm").serializeJSON() , function(result) {
			if(result > 0){
				Common.ajax("GET", "/commission/calculation/CFFDeactivate", $("#conForm").serializeJSON() , function(result) {
					Common.alert('<spring:message code="commission.alert.incentive.confirm.deactivate.success"/>');
					$("#clearComfirm").click();
				});
			}else{
				Common.alert('<spring:message code="commission.alert.incentive.confirm.deactivate.fail"/>');
			}
		});
	}

	//master confirm button
	function fn_confirm(){
		if(Number($("#cntValid").val()) < 1){
			Common.alert('<spring:message code="commission.alert.incentive.confirm.fail"/>');
		}else{
			Common.ajax("GET", "/commission/calculation/cffConfirm", $("#conForm").serializeJSON() , function(result) {
				console.log(result.message);
				if(result.message != null ){
					Common.alert("<spring:message code='commission.alert.incentive.noValid' arguments='"+result.message+"' htmlEscape='false'/>");
				}else{
					Common.alert('<spring:message code="commission.alert.incentive.confirm.fail"/>');
					$("#clearComfirm").click();
				}
			});
		}
	}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='commission.title.pop.head.cffConfirm'/></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="clearComfirm"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code='commission.text.search.batchId'/></th>
	<td>${detail.UPLOAD_ID }</td>
	<th scope="row"><spring:message code='commission.text.search.uploadBy'/></th>
	<td>${detail.CRT_USER_NAME } (${detail.CRT_DT} )</td>
</tr>
<tr>
	<th scope="row"><spring:message code='commission.text.search.status'/></th>
	<td>${detail.NAME }</td>
	<th scope="row"><spring:message code='commission.text.search.updateBy'/></th>
	<td>${detail.UPD_USER_NAME } (${detail.UPD_DT })</td>
</tr>
<tr>
	<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
    <td>${detail.CODENAME1 }</td>
	<th scope="row"><spring:message code='commission.text.search.targetMonth'/></th>
	<td>${detail.ACTN_DT }</td>
</tr>
<tr>
	<th scope="row"><spring:message code='commission.text.search.totalItem'/></th>
	<td><p id="totalCntTxt">${totalCnt}</p></td>
	<th scope="row"><spring:message code='commission.text.search.totalVaild'/></th>
	<td><p id="totalValidTxt">${totalValid }</p><p> / </p><p id="totalInvalidTxt">${totalInvalid }</p>
	<input type="hidden" name="cntValid" id="cntValid" value="${totalValid }"></td>
</tr>
</tbody>
</table><!-- table end -->

<form id="conForm" name="conForm">
	<input type="hidden" name="uploadId" id="uploadUserId" value="${uploadId }">
	<input type="hidden" name="uploadTypeId" id="uploadTypeId" value="${detail.UPLOAD_TYPE_ID }">
	<input type="hidden" name="typeCd" id="uploadTypeCd" value="${typeId }">
	<input type="hidden" name="vStusId" id="vStusId">
</form>

<ul class="right_btns">
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('0');"><spring:message code='commission.button.allItem'/></a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('4');"><spring:message code='commission.button.viildItem'/></a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('21');"><spring:message code='commission.button.invaildItem'/></a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemAdd();"><spring:message code='commission.button.addItem'/></a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_removeItem();"><spring:message code='commission.button.removeItem'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_confirm" style="width: 100%; height: 280px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue"><a href="javascript:fn_confirm();"><spring:message code='commission.button.confirm'/></a></p></li>
	<li><p class="btn_blue"><a href="javascript:fn_deactivate();"><spring:message code='commission.button.deactivate'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->