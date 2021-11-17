<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
var itemGridID;
    $(document).ready(function() {
        createAUIGrid();
        fn_itemDetailSearch('');

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
            dataField : "lotyMemberCode",
            headerText : "MemberCode",
            style : "my-column",
            editable : false
        },{
            dataField : "name",
            headerText : "MemberName",
            style : "my-column",
            editable : false
        },{
            dataField : "lotyMemberStatusCode",
            headerText : "HP Status",
            style : "my-column",
            editable : false
        },{
            dataField : "codeName",
            headerText : "RefCode",
            style : "my-column",
            editable : false
        },{
            dataField : "lotyStartDate",
            headerText : "Start Date",
            style : "my-column",
            editable : false,
            dataType : "date", formatString : "dd-mm-yyyy"

        },{
            dataField : "lotyEndDate",
            headerText : "End Date",
            style : "my-column",
            editable : false,
            dataType : "date", formatString : "dd-mm-yyyy"
        },{
            dataField : "lotyPeriod",
            headerText : "Period",
            style : "my-column",
            editable : false
        },{
            dataField : "lotyYear",
            headerText : "Year",
            style : "my-column",
            editable : false

        }
        ,{
            dataField : "lotyUploadId",
            headerText : "lotyUploadId",
            style : "my-column",
            editable : false ,visible : false
        }
        ];

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

    function fn_itemDetailSearch(type){
    	 Common.ajax("GET", "/organization/selectToyaltyHpUploadDetailList?uploadId="+"${uploadId}&lotyMemberStatus="+type , $("#conForm").serializeJSON(), function(result) {
             AUIGrid.setGridData(itemGridID, result.dataList);

             $("#txUploadId").text(result.info.lotyUploadId);
             $("#txStatusCode").text(result.info.lotyUploadStatusName);
             $("#txUpdateBy").text(result.info.updateor+"( "+ result.info.lotyupdate +" )");             $("#txTotailItem").text(result.info.totCnt);
             $("#txTotailItem").text(result.info.totCnt);
             $("#txTotalValidTxt").text(result.info.valCnt);
             $("#tXTotalInvalidTxt").text(result.info.inValCnt);

             console.log(result)

         });

    }

    function fn_itemAdd(){
        Common.popupDiv("/organization/loyaltyHPUploadAddItemPop.do?uploadId="+"${uploadId}",$("#conForm").serializeJSON());
    }

    function fn_removeItem(){
        Common.ajax("POST", "/organization/removeLoyaltyHpUpload", GridCommon.getEditData(itemGridID) , function(result) {
            Common.alert('<spring:message code="commission.alert.incentive.itemRemove"/>');
            fn_itemDetailSearch('');
        });
    }

    function fn_deactivate(){
        var valTemp = {"uploadId" : $('#uploadUserId').val()};
        Common.ajax("GET", "/commission/calculation/deactivateCheck", $("#conForm").serializeJSON() , function(result) {
            if(result > 0){
                Common.ajax("GET", "/commission/calculation/mboDeactivate", $("#conForm").serializeJSON() , function(result) {
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

        if(Number($("#txTotalValidTxt").text()) < 1){
            Common.alert('<spring:message code="commission.alert.incentive.confirm.fail"/>');
        }else{
            Common.ajax("GET", "/organization/confrimItemLoyaltyHpUpload?uploadId="+"${uploadId}", $("#conForm").serializeJSON() , function(result) {
                if(result.message != null){
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
<h1>LOYALTY HP PROGRAM UPLOAD -VIEW UPLOAD BATCH</h1>
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
      <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='commission.text.search.batchId'/></th>
    <td> <span id=txUploadId></span></td>

    <th scope="row"><spring:message code='commission.text.search.status'/></th>
    <td><span id=txStatusCode></span></td>

    <th scope="row"><spring:message code='commission.text.search.uploadBy'/></th>
    <td><span id=txUpdateBy></span></td>
</tr>


<tr>
    <th scope="row"><spring:message code='commission.text.search.totalItem'/></th>
    <td><span id="txTotailItem"></td>
    <th scope="row"><spring:message code='commission.text.search.totalVaild'/></th>
    <td colspan="3" ><p id="txTotalValidTxt"></p><p> / </p><p id="tXTotalInvalidTxt"></p>
</tr>

</tbody>
</table><!-- table end -->

<form id="conForm" name="conForm">
</form>

<ul class="right_btns">
    <li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('');"><spring:message code='commission.button.allItem'/></a></p></li>
    <li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('1');"><spring:message code='commission.button.viildItem'/></a></p></li>
    <li><p class="btn_grid"><a href="javascript:fn_itemDetailSearch('0');"><spring:message code='commission.button.invaildItem'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_confirm" style="width: 100%; height: 280px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->



</section><!-- pop_body end -->

</div><!-- popup_wrap end -->