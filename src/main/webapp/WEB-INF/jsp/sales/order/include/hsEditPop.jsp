<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

// add by jgkim
var myDetailGridData = null;

    //Combo Data
    var StatusTypeData2 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];

    // AUIGrid 생성 후 반환 ID
    var myDetailGridID;
    var myDetailGridID2;
    var myDetailGridID3;

    function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField:"stkCode",
                    headerText:"Filter Code",
                    width:200,
                    height:30
                }, {
                    dataField : "stkId",
                    headerText : "Filter id",
                    width : 140,
                    visible:false
                }, {
                    dataField : "stkDesc",
                    headerText : "Filter Name",
                    width : 440
                    }, {
                    dataField : "bsResultItmId",
                    headerText : "Filter Name",
                    width : 240    ,
                    visible:false
                }, {
                    dataField : "name",
                    headerText : "Filter Quantity",
                    width : 120,
                    dataType : "numeric",
                    editRenderer : {
                        type : "NumberStepRenderer",
                        min : 0,
                        max : 50,
                        step : 1,
                        textEditable : true
                    }
            }];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,

                editable : false,

                //showStateColumn : true,

                //displayTreeOpen : true,

                headerHeight : 30,

                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,

                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,

                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true

            };

            //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
            myDetailGridID = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);

            AUIGrid.bind(myDetailGridID, "cellEditBegin", function (event){
                if (event.columnIndex == 4){
                    if ($("#cmbStatusType2").val() == 4) {    // Completed
                        return true;
                    } else if ($("#cmbStatusType2").val() == 21) {    // Failed
                        return false;
                    } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
                        return false;
                    } else {
                        return false;
                    }
                }
            });
    }

    function createAUIGrid2(){
        // AUIGrid 칼럼 설정
        var resultColumnLayout = [ {
                    dataField:"resultIsCurr",
                    headerText:"Version",
                    width:200,
                    height:30
                }, {
                    dataField : "no",
                    headerText : "BSR No",
                    width : 140
                }, {
                    dataField : "code",
                    headerText : "Status",
                    width : 440
                }, {
                    dataField : "memCode",
                    headerText : "Member",
                    width : 240
                }, {
                    dataField : "setlDt",
                    headerText : "Settle Date",
                    width : 240 ,
                    dataType : "date",
                    formatString : "dd/mm/yyyy"
                }, {
                    dataField : "resultStockUse",
                    headerText : "Has Filter",
                    width : 240
                }, {
                    dataField : "resultCrtDt",
                    headerText : "Key At",
                    width : 240,
                    dataType : "date",
                    formatString : "dd/mm/yyyy"
                }, {
                    dataField : "userName",
                    headerText : "Key By",
                    width : 240
                }];

            // 그리드 속성 설정
            var gridPros = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
                selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"

            };

            myDetailGridID2 = GridCommon.createAUIGrid("hsResult_grid_wrap", resultColumnLayout,'', gridPros);
    }

    function createAUIGrid3(){
        // AUIGrid 칼럼 설정
        var fitercolumnLayout = [ {
                    dataField:"no",
                    headerText:"BSR No",
                    width:200,
                    height:30
                }, {
                    dataField : "stkDesc",
                    headerText : "Filter",
                    width : 140
                }, {
                    dataField : "bsResultPartQty",
                    headerText : "Qty",
                    width : 90
                }, {
                    dataField : "bsResultFilterClm",
                    headerText : "Claim",
                    width : 240    ,
                    visible:false
               }, {
                    dataField : "resultCrtDt",
                    headerText : "Key At",
                    width : 240        ,
                    visible:false
               }, {
                    dataField : "userName",
                    headerText : "Key By",
                    width : 240       ,
                    visible:false

            }];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,

                editable : false,

                headerHeight : 30,

                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,

                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,

                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true

            };

            myDetailGridID3 = GridCommon.createAUIGrid("fiter_grid_wrap", fitercolumnLayout, '',gridPros);
    }




    $(document).ready(function() {

    	   doDefCombo(StatusTypeData2, '' ,'cmbStatusType2', 'S', '');

           selSchdulId = $("#hidschdulId").val(); // TypeId
           selSalesOrdId = $("#hidSalesOrdId").val(); // TypeId
           openGb = $("#openGb").val(); // TypeId
           brnchId = $("#brnchId").val(); // TypeId
           hidHsno = $("#hidHsno").val(); // TypeId
           hrResultId = $("#hrResultId").val(); // TypeId

           createAUIGrid();
           createAUIGrid2();
           createAUIGrid3();

           fn_getHsViewfilterInfoAjax();

           var statusCd = "${basicinfo.stusCodeId}";
           $("#cmbStatusType2 option[value='"+ statusCd +"']").attr("selected", true);

            var failResnCd = "${basicinfo.failResnId}";
            //alert("fail reason : " + failResnCd);
            if(failResnCd != "0" ){
                $("#failReason option[value='"+ failResnCd +"']").attr("selected", true);
                //$("#failReason option[value='60']").attr("selected", true);
            }else{
            	$("#failReason").find("option").remove();
            }

           var codyIdCd = "${basicinfo.codyId}";
           $("#cmbServiceMem option[value='"+codyIdCd +"']").attr("selected", true);

           var renColctCd = "${basicinfo.renColctId}";
           /* if(renColctCd != "0" ){
        	   $("#cmbCollectType option[value='"+renColctCd +"']").attr("selected", true);
           }else{
               $("#cmbCollectType").find("option").remove();
           } */
           $("#cmbCollectType option[value='"+renColctCd +"']").attr("selected", true);

             if($("#_openGb").val() == "view"){
                    $("#btnSave").hide();
            }

            if('${MOD}' =="VIEW"){
               $("#stitle").text("HS - Result View")	;
               $("#editHSResultForm").find("input, textarea, button, select").attr("disabled",true);


            }else {
                $("#stitle").text("HS - Result EDIT")  ;

                if($("#stusCode").val()==4) {
                    $("#editHSResultForm").find("input, textarea, button, select").attr("disabled",false);
                    $('#cmbCollectType').removeAttr('disabled');
                }
            }

            // HS Result Information > HS Status 값에 따라 다른 정보 입력 가능 여부 설정
            if ($("#cmbStatusType2").val() == 4) {    // Completed
                    $("input[name='settleDt']").attr('disabled', false);
                    $("select[name='failReason'] option").remove();
            } else if ($("#cmbStatusType2").val() == 21) {    // Failed
                $('#settleDt').val('');
                $("input[name='settleDt']").attr('disabled', true);
            } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
                $('#settleDt').val('');
                $("input[name='settleDt']").attr('disabled', true);
            }

            $("#cmbStatusType2").change(function(){

                AUIGrid.forceEditingComplete(myDetailGridID, null, false);
                AUIGrid.updateAllToValue(myDetailGridID, "name", '0');

                if ($("#cmbStatusType2").val() == 4) {    // Completed
                    $("input[name='settleDt']").attr('disabled', false);
                    $("select[name='failReason'] option").remove();
                } else if ($("#cmbStatusType2").val() == 21) {    // Failed
                    doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
                    $('#settleDt').val('');
                    $("input[name='settleDt']").attr('disabled', true);
                } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
                    doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
                    $('#settleDt').val('');
                    $("input[name='settleDt']").attr('disabled', true);
                }

            });

    });

    function fn_getHsViewfilterInfoAjax(){
    	 Common.ajax("GET", "/services/bs/selectHsViewfilterPop.do",{selSchdulId : selSchdulId}, function(result) {
             console.log("성공 fn_getHsViewfilterInfoAjax.");
             console.log("data : " + result);

             AUIGrid.setGridData(myDetailGridID, result);

             // Grid 안의 값이 음수인 경우 0으로 출력
             var cnt = result.length;
             for (var i=0; i<cnt; i++) {
                 var minusCheck = AUIGrid.getCellValue(myDetailGridID, i, "name");
                 if (minusCheck < 0) {
                     AUIGrid.updateRow(myDetailGridID, { name : "0" }, i, false);
                 }
             }

             myDetailGridData = result;
         });

         Common.ajax("GET", "/services/bs/selectHistoryHSResult.do",{selSchdulId : selSchdulId}, function(result) {
            console.log("성공 selectHistoryHSResult.");
            console.log("data : " + result);
            AUIGrid.setGridData(myDetailGridID2, result);
        });


         Common.ajax("GET", "/services/bs/selectFilterTransaction.do",{selSchdulId : selSchdulId}, function(result) {
            console.log("성공 selectFilterTransaction.");
            console.log("data : " + result);
            AUIGrid.setGridData(myDetailGridID3, result);
        });
    }

    //resize func (tab click)
    function fn_resizefunc(obj, gridName){ //

        var $this = $(obj);
        var width = $this.width();
        AUIGrid.resize(gridName, width, 200);
    }
</script>

<div id="popup_Editwrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->

<h1>  <spin id='stitle'>  </spin></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="popClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="editHSResultForm" method="post">

<aside class="title_line"><!-- title_line start -->
<h2>HS Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:90px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS No</th>
    <td><span><c:out value="${basicinfo.no}"/></span></td>
    <th scope="row">HS Month</th>
    <td><span><c:out value="${basicinfo.monthy}"/></span></td>
    <th scope="row">HS Type</th>
    <td colspan="3"><span><c:out value="${basicinfo.codeName}"/></span></td>
</tr>
<tr>
    <th scope="row">Current BSR No</th>
    <td><span><c:out value="${basicinfo.c1}"/></span></td>
    <th scope="row">Prev HS Area</th>
    <td><span><c:out value="${basicinfo.prevSvcArea}"/></span></td>
    <th scope="row">Next HS Area</th>
    <td><span><c:out value="${basicinfo.nextSvcArea}"/></span></td>
     <th scope="row">Distance</th>
    <td><span><c:out value="${basicinfo.distance}"/></span></td>
</tr>


</tbody>
</table><!-- table end -->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID2)">Current & History HS Result</a></dt>
    <dd>
        <article class="grid_wrap"><!-- grid_wrap start -->
             <div id="hsResult_grid_wrap" style="width:100%; height:210px; margin:0 auto;"></div>
        </article><!-- grid_wrap end -->
    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID3)">Filter Transaction</a></dt>
    <dd>
        <article class="grid_wrap"><!-- grid_wrap start -->
         <div id="fiter_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </dd>
</dl>
</article><!-- acodi_wrap end -->


<aside class="title_line mt20"><!-- title_line start -->
<h2>HS Result Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:350px;" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS Status<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbStatusType2" name = "cmbStatusType2"></select>
    </td>
    <th scope="row" style="width: 186px; ">Settle Date</th>
    <td>
        <%-- <span><c:out value="${basicinfo.setlDt}"/></span> --%>
        <input type="text" title="Settle Date" placeholder="DD/MM/YYYY" class="w100p readonly" id="settleDt" name="settleDt" value="${basicinfo.setlDt}" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Fail Reason</th>
    <td>
    <select class="w100p" id ="failReason"  name ="failReason">
       <c:forEach var="list" items="${failReasonList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row" style="width: 244px; ">Collection Code<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
        <option value="0" selected>Choose One</option>
            <c:forEach var="list" items="${cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select>
    </td>
</tr>
<%-- <tr>
    <th scope="row">Service Member</th>
    <td>
    <select class="w100p" id ="cmbServiceMem" name = "cmbServiceMem">
       <c:forEach var="list" items="${ serMemList}" varStatus="status">
            <option value="${list.codeId}">${list.codeName } </option>
       </c:forEach>
    </select>
    </td>
    <th scope="row">Warehouse</th>
    <td>
    <select class="w100p" id ="wareHouse" name ="wareHouse">

    </select>
    </td>
</tr> --%>
<tr>
    <th scope="row" style="width: 176px; ">Remark</th>
    <td>
        <input id="txtRemark" name="txtRemark"  type="text" title="" placeholder="Remark" class="w100p" value="${basicinfo.resultRem}"/>
        <%-- <span>${basicinfo.resultRem}</span> --%>
    </td>
    <th scope="row" style="width: 59px; ">Instruction</th>
    <td>
        <input id="txtInstruction" name="txtInstruction"  type="text" title="" placeholder="Instruction" class="w100p" value="${settleInfo.configBsRem}"/>
        <%-- <span>${settleInfo.configBsRem}</span> --%>
    </td>
</tr>
<tr>
    <th scope="row">Prefer Service Week</th>
    <td colspan="1">
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span>None</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 1}">checked</c:if> /><span>Week1</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 2}">checked</c:if> /><span>Week2</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 3}">checked</c:if> /><span>Week3</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> /><span>Week4</span></label>

 <%--    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> disabled/><span>Week4</span></label> --%>
    </td>
        <th scope="row" style="width: 186px; ">Cancel Request Number</th>
    <td>
        <input id="txtCancelRN" name="txtCancelRN"  type="text" title="" placeholder="N/A" class="w100p" value="${basicinfo.cancReqNo}"  readonly />
        <%-- <span><c:out value="${basicinfo.cancReqNo}"/></span>  --%>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Filter Information</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
	 <div id="grid_wrap1" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">

<!--     <li><p class="btn_blue2 big"><a href="#" id="_close" onclick="javascript: fn_closeFunc()">Close</a></p></li> -->
<!--     <li><p class="btn_blue2 big"><a href="#">Close</a></p></li> -->
</ul>


 <div  style="display:none">

 <input type="text" value="${basicinfo.schdulId}" id="hidschdulId" name="hidschdulId"/>
 <input type="text" value="${basicinfo.salesOrdId}" id="hidSalesOrdId" name="hidSalesOrdId"/>
 <input type="text" value="${basicinfo.no}" id="hidHsno" name="hidHsno"/>
 <input type="text" value="${basicinfo.c2}" id="hrResultId" name="hrResultId"/>
 <input type="text" value="${basicinfo.srvBsWeek}" id="srvBsWeek" name="srvBsWeek"/>
 <input type="text" value="${basicinfo.codyId}" id="cmbServiceMem" name="cmbServiceMem"/>


 <input type="text" value="<c:out value="${basicinfo.stusCodeId}"/> "  id="stusCode" name="stusCode"/>
 <input type="text" value="<c:out value="${basicinfo.failResnId}"/> "  id="failResn" name="failResn"/>
 <input type="text" value="<c:out value="${basicinfo.renColctId}"/> "  id="renColct" name="renColct"/>
 <input type="text" value="<c:out value="${basicinfo.codyId}"/> "  id="codyId" name="codyId"/>
 <input type="text" value="<c:out value="${basicinfo.setlDt}"/> "  id="setlDt" name="setlDt"/>
 <input type="text" value="<c:out value="${basicinfo.configBsRem}"/> "  id="configBsRem" name="configBsRem"/>
 <input type="text" value="<c:out value="${basicinfo.configBsRem}"/> "  id="Instruction" name="Instruction"/>
 <input type="text" value=""  id="cmbCollectType1" name="cmbCollectType1"/>

 </div>

</form>
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
