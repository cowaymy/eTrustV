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
            headerText : "Member Code",
            style : "my-column",
            editable : false
        },{
            dataField : "codeNm",
            headerText : "Type",
            style : "my-column",
            editable : false
        },{
            dataField : "memNm",
            headerText : "Member Name",
            style : "my-column",
            editable : false
        },{
            dataField : "code",
            headerText : "Status",
            style : "my-column",
            editable : false
        },{
            dataField : "validRem",
            headerText : "Remark",
            style : "my-column",
            editable : false
        },{
            dataField : "userTrgetAmt",
            headerText : "Target AMT",
            style : "my-column",
            editable : false
        },{
            dataField : "userRefCode",
            headerText : "Ref Code",
            style : "my-column",
            editable : false
        },{
            dataField : "userRefLvl",
            headerText : "Lvl",
            style : "my-column",
            editable : false
        },{
            dataField : "uploadDetId",
            style : "my-column",
            visible : false,
            editable : false
        }];
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            height : 300
            
        };
        
        itemGridID = AUIGrid.create("#grid_wrap_confirm", columnLayout,gridPros);
   }
	
	
	//incentive valid / inValid List search
	function fn_itemDetailSearch(val){
		if(val == "0"){
			$("#vStusId").val("");
			Common.ajax("GET", "/commission/calculation/incentiveItemList", $("#conForm").serializeJSON(), function(result) {
                AUIGrid.setGridData(itemGridID, result);
            });
		}else{
			$("#vStusId").val(val);
            Common.ajax("GET", "/commission/calculation/incentiveItemList", $("#conForm").serializeJSON(), function(result) {
                AUIGrid.setGridData(itemGridID, result);
            });
		}
	}
	
	//item Add Pop
	function fn_itemAdd(){
		Common.popupDiv("/commission/calculation/commInctivItemAddPop.do",$("#conForm").serializeJSON());
	}
	
	//item RemoveAjax
	function fn_removeItem(){
		Common.ajax("POST", "/commission/calculation/removeIncentiveItem.do", GridCommon.getEditData(itemGridID) , function(result) {
			Common.alert("The item has been removed.");
			$("#totalCntTxt").text(result.data.totalCnt);
            $("#totalValidTxt").text(result.data.totalValid);
            $("#totalInvalidTxt").text(result.data.totalInvalid);
            $("#cntValid").val(result.data.totalValid);
			fn_itemDetailSearch('0');
		});
	}
	
	//master deactivate button
	function fn_deactivate(){
		var valTemp = {"uploadId" : $('#uploadUserId').val()};
		Common.ajax("GET", "/commission/calculation/deactivateCheck", $("#conForm").serializeJSON() , function(result) {
			if(result > 0){
				Common.ajax("GET", "/commission/calculation/incentiveDeactivate", $("#conForm").serializeJSON() , function(result) {
					//Common.alert('<spring:message code="commission.alert.incentive.confirm.deactivate.success"/>');
					Common.alert("This upload batch has been deactivated.");
					$("#clearComfirm").click();
					//$("#search").click();
	                //$("#popup_wrap").remove();
				});
			}else{
				//Common.alert('<spring:message code="commission.alert.incentive.confirm.deactivate.fail"/>');
				Common.alert("Failed to deactivate upload batch. Please try again later.");
			}
		});
	}
	
	//master confirm button
	function fn_confirm(){
		if(Number($("#cntValid").val()) < 1){
			//Common.alert('<spring:message code="commission.alert.incentive.confirm.fail"/>');
			Common.alert("No valid item in this batch.");
		}else{
			Common.ajax("GET", "/commission/calculation/incentiveConfirm", $("#conForm").serializeJSON() , function(result) {
				//Common.alert('<spring:message code="commission.alert.incentive.confirm.success"/>');
				if(result.message != null){
					Common.alert("No valid in this batch </br> "+result.message);
				}else{
					Common.alert("This upload batch has been confirmed and saved.");
					$("#clearComfirm").click();
				}
				//$("#search").click(); //TODO close 시점으로 바꿔야함
				//$("#popup_wrap").remove();
			});
		}
	}
	
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>INCENTIVE/TARGET UPLOAD - CONFIRM UPLOAD BATCH</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#" id="clearComfirm">CLOSE</a></p></li>
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
	<th scope="row">Bath ID</th>
	<td>${detail.UPLOAD_ID }</td>
	<th scope="row">Upload By</th>
	<td>${detail.CRT_USER_NAME } (${detail.CRT_DT} )</td>
</tr>
<tr>
	<th scope="row">Status</th>
	<td>${detail.NAME }</td>
	<th scope="row">Update By</th>
	<td>${detail.UPD_USER_NAME } (${detail.UPD_DT })</td>
</tr>
<tr>
	<th scope="row">Upload Type</th>
	<td>${detail.CODE_NAME }</td>
	<th scope="row">Target Month</th>
	<td>${detail.ACTN_DT }</td>
</tr>
<tr>
	<th scope="row">Total Item</th>
	<td><p id="totalCntTxt">${totalCnt }</p></td>
	<th scope="row">Total Vaild / Invaild</th>
	<td><p id="totalValidTxt">${totalValid }</p><p> / </p><p id="totalInvalidTxt">${totalInvalid }</p>
	<input type="hidden" name="cntValid" id="cntValid" value="${totalValid }"></td>
</tr>
<tr>
	<th scope="row">Member Type</th>
	<td colspan="3">${detail.CODENAME1 }</td>
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
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('0');">ALL Items</a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('4');">Vaild Items</a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('21');">Invaild Items</a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_itemAdd();">Add Item</a></p></li>
	<li><p class="btn_grid"><a href="javascript:fn_removeItem();">remove Items</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_confirm" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue"><a href="javascript:fn_confirm();">Confirm</a></p></li>
	<li><p class="btn_blue"><a href="javascript:fn_deactivate();">Deactivate</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->