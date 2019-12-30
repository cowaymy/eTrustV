<!--=================================================================================================
* Task  : Logistics
* File Name : countStockAuditDetailPop.jsp
* Description : Count-Stock Audit Detail
* Author : KR-OHK
* Date : 2019-10-17
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-17  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.auto_file4{position:relative; width:237px; padding-right:62px; height:20px;}
.auto_file4{float:none!important; width:490px; padding-right:0; margin-top:5px;}
.auto_file4:first-child{margin-top:0;}
.auto_file4:after{content:""; display:block; clear:both;}
.auto_file4.w100p{width:100%!important; box-sizing:border-box;}
.auto_file4 input[type=file]{display:block; overflow:hidden; position:absolute; top:-1000em; left:0;}
.auto_file4 label{display:block; margin:0!important;}
.auto_file4 label:after{content:""; display:block; clear:both;}
.auto_file4 label{float:left; width:300px;}
.auto_file4 label input[type=text]{width:100%!important;}
.auto_file4 label input[type=text]{width:237px!important; float:left}
.auto_file4 span.label_text{float:left;}
.auto_file4 span.label_text a{display:block; height:20px; line-height:20px; margin-left:5px; min-width:47px; text-align:center; padding:0 5px; background:#a1c4d7; color:#fff; font-size:11px; font-weight:bold; border-radius:3px;}
</style>

<script type="text/javascript">

	var dedRsnList = [];
	var otherGiRsnList = [];
	var otherGrRsnList = [];
	var comDedRsnList = [];
	var comOtherRsnList = [];

    var locGrid, itemGrid;

    var locColumnLayout=[
                         {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>",width:1, visible:false },
                         {dataField: "historyYn",headerText :"<spring:message code='log.head.locationid'/>", width: 1, visible:false },
                         {dataField: "whLocId",headerText :"<spring:message code='log.head.locationid'/>", width: 90, editable : false },
                         {dataField: "codeName",headerText :"<spring:message code='log.head.locationtype'/>", width: 110, editable : false},
                         {dataField: "whLocCode",headerText :"<spring:message code='log.head.locationcode'/>", width: 120, editable : false},
                         {dataField: "whLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: 140, editable : false, style: "aui-grid-user-custom-left"},
                         {dataField: "seq",headerText :"<spring:message code='log.head.historyNo'/>", width: 80, editable : false},
                         {dataField: "locStusCodeNm",headerText :"<spring:message code='log.head.locationStatus'/>", width: 120, editable : false},
                         {dataField: "lastApproverNm",headerText :"<spring:message code='log.head.lastApprover'/>", width: 140, editable : false, style: "aui-grid-user-custom-left"},
                         {dataField: "lastApproveDate",headerText :"<spring:message code='log.head.lastApproveDate'/>", width: 140, editable : false,
                        	 dataType: "date",
                             formatString: "dd/mm/yyyy"
                         },
                         {dataField: "lastApproverOpinion",headerText :"<spring:message code='log.head.lastApproverOpinion'/>", width: 200, editable : false, style: "aui-grid-user-custom-left"}
                 ];

    var itemColumnLayout=[
                          {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false },
                          {dataField: "historyYn",headerText :"<spring:message code='log.head.locationid'/>", width: 1, visible:false },
                          {dataField: "itmId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false},
                          {dataField: "whLocId",headerText :"<spring:message code='log.head.locationid'/>", width: 90 },
                          {dataField: "locType",headerText :"<spring:message code='log.head.locationtype'/>", width: 110},
                          {dataField: "whLocCode",headerText :"<spring:message code='log.head.locationcode'/>", width: 120},
                          {dataField: "whLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: 140, style: "aui-grid-user-custom-left"},
                          {dataField: "stkCode",headerText :"<spring:message code='log.head.itemcode'/>",width: 90, editable : false},
                          {dataField: "stkDesc",headerText :"<spring:message code='log.head.itemname'/>",width: 130, editable : false, style: "aui-grid-user-custom-left"},
                          {dataField: "seq",headerText :"<spring:message code='log.head.historyNo'/>", width: 80, editable : false},
                          {dataField: "stkGrad",headerText :"<spring:message code='log.head.locationgrade'/>" ,width:120, editable : false},
                          {dataField: "stkType",headerText :"<spring:message code='log.head.itemtype'/>" ,width: 90, editable : false },
                          {dataField: "stkCtgryType",headerText :"<spring:message code='log.head.categoryType'/>", width: 110, editable : false },
                          {dataField: "sysQty",headerText :"<spring:message code='log.head.systemqty'/>",width:90, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "cntQty",headerText :"<spring:message code='log.head.countqty'/>", width:90, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "diffQty",headerText :"<spring:message code='log.head.variance'/>", width:200, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "dedQty",headerText :"Deduction Qty", width:130, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "dedReason",headerText :"Deduction Reason", width:250, editable : false,
                        	  labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                                  var retStr = value;
                                  comDedRsnList.length = 0;

                                  if(item.dedQty == 0) {
                                	   comDedRsnList.push(dedRsnList[0]);
                                  } else {
                                      for(var i=0,len=dedRsnList.length; i<len; i++) {
                                           comDedRsnList.push(dedRsnList[i]);
                                      }
                                  }

                                  for(var i=0,len=comDedRsnList.length; i<len; i++) {
                                      if(comDedRsnList[i]["code"] == value) {
                                          retStr = comDedRsnList[i]["codeName"];
                                          break;
                                      }
                                  }
                                  return retStr;
                              },
                              editRenderer : {
                                  type : "DropDownListRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  list : comDedRsnList, //key-value Object 로 구성된 리스트
                                  keyField : "code", // key 에 해당되는 필드명
                                  valueField : "codeName", // value 에 해당되는 필드명
                                  listAlign : "left"
                              },
                          },
                          {dataField: "otherQty",headerText :"OtherGI/GR QTY", width:130, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "otherReason",headerText :"OtherGI/GR Reason", width:250, editable : false,
                        	  labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                                  var retStr = value;
                                  comOtherRsnList.length = 0;

                                  if(item.otherQty > 0) {               // Other GR
                                      for(var i=0,len=otherGrRsnList.length; i<len; i++) {
                                          comOtherRsnList.push(otherGrRsnList[i]);
                                      }
                                  } else if(item.otherQty < 0 ) {   // Other GI
                                       for(var i=0,len=otherGiRsnList.length; i<len; i++) {
                                           comOtherRsnList.push(otherGiRsnList[i]);
                                      }
                                  } else {
                                     comOtherRsnList.push(otherGiRsnList[0]);
                                  }

                                  for(var i=0,len=comOtherRsnList.length; i<len; i++) {
                                      if(comOtherRsnList[i]["code"] == value) {
                                          retStr = comOtherRsnList[i]["codeName"];
                                          break;
                                      }
                                  }
                                  return retStr;
                              },
                              editRenderer : {
                                  type : "DropDownListRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  list : comOtherRsnList, //key-value Object 로 구성된 리스트
                                  keyField : "code", // key 에 해당되는 필드명
                                  valueField : "codeName", // value 에 해당되는 필드명
                                  listAlign : "left"
                              },
                          },
                          {dataField: "rem",headerText :"<spring:message code='log.head.remark'/>", width:500, editable : false, style: "aui-grid-user-custom-left"}
                  ];

    var locop = {
            rowIdField : "num",
            showRowCheckColumn : false,
            showStateColumn : false,      // 상태 칼럼 사용
            usePaging : false,
            editable : false};

    var itemop = {
            rowIdField : "rnum",
            showRowCheckColumn : false,
            editable : false,
            usePaging : false, //페이징 사용
            showStateColumn : false,
            headerHeight: 35
            };

    $(document).ready(function () {

        doGetComboCodeId('/logistics/adjustment/selectLocCodeList.do', {stockAuditNo : '${docInfo.stockAuditNo}'}, '', 'locWhLocId', 'A', '');
        doGetComboCodeId('/logistics/adjustment/selectLocCodeList.do', {stockAuditNo : '${docInfo.stockAuditNo}'}, '', 'itemWhLocId', 'A', '');

        fn_reasonCodeSearch();

        locGrid = GridCommon.createAUIGrid("loc_grid_wrap_pop", locColumnLayout,"", locop);
        AUIGrid.setGridData(locGrid, $.parseJSON('${locList}'));

        itemGrid = GridCommon.createAUIGrid("item_grid_wrap_pop", itemColumnLayout,"", itemop);
        AUIGrid.setGridData(itemGrid, $.parseJSON('${itemList}'));

        fn_setVal();

        AUIGrid.setFilterByValues(locGrid, "historyYn", "N");
        AUIGrid.setFilterByValues(itemGrid, "historyYn", "N");

        $("input[name=attachFile1]").on("dblclick", function () {

            Common.showLoader();

            var $this = $(this);
            var fileId = $this.attr("data-id");

            $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
                httpMethod: "POST",
                contentType: "application/json;charset=UTF-8",
                data: {
                    fileId: fileId
                },
                failCallback: function (responseHtml, url, error) {
                    Common.alert($(responseHtml).find("#errorMessage").text());
                }
            })
                .done(function () {
                    Common.removeLoader();
                    console.log('File download a success!');
                })
                .fail(function () {
                    Common.removeLoader();
                });
            return false; //this is critical to stop the click event which will trigger a normal file download
        });

        // cellClick event.
        AUIGrid.bind(locGrid, "cellClick", function( event )
        {
            var whLocId = AUIGrid.getCellValue(locGrid, event.rowIndex, "whLocId");
            AUIGrid.setFilterByValues(itemGrid, "whLocId", [whLocId]);
        });
    });

    function fn_close() {
        $("#popClose").click();
    }

    //excel Download
    $('#excelDownDet').click(function() {
        GridCommon.exportTo("item_grid_wrap_pop", 'xlsx', "Count Stock Audit Item List");
    });

    function fn_setVal(){

    	var locType =  $("#hidLocType").val();
    	var itmType =  $("#hidItmType").val();
    	var ctgryType =  $("#hidCtgryType").val();

    	var tmp1 = locType.split(',');
        var tmp2 = itmType.split(',');
        var tmp3 = ctgryType.split(',');

        fn_itemSet(tmp1,"event");
        fn_itemSet(tmp2,"item");
        fn_itemSet(tmp3,"catagory");

    }

    function fn_itemSet(tmp,str){
        var no;
        if(str=="event"){
            no=339;
        }else if(str=="item"){
            no=15;
        }else if(str=="catagory"){
            no=11;
        }
        var url = "/logistics/adjustment/selectCodeList.do";
        $.ajax({
            type : "GET",
            url : url,
            data : {
                groupCode : no
            },
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                 fn_itemChck(data,tmp,str);
            },
            error : function(jqXHR, textStatus, errorThrown) {
            },
            complete : function() {
            }
        });
    }

    function  fn_itemChck(data,tmp2,str){
        var obj;
        if(str=="event" ){
            obj ="eventtypetd";
        }else if(str=="item"){
            obj ="itemtypetd";
        }else if(str=="catagory"){
            obj ="catagorytypetd";
        }
        obj= '#'+obj;

        $.each(data, function(index,value) {
                    $('<label>',{id:data[index].code}).appendTo(obj);
                    $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo("#"+data[index].code).attr("disabled","disabled");
                    $('<span />',  {text:data[index].codeName}).appendTo("#"+data[index].code);
            });

            for(var i=0; i<tmp2.length;i++){
                $.each(data, function(index,value) {
                    if(tmp2[i]==data[index].codeId){
                        $("#"+data[index].codeId).attr("checked", "true");
                    }
                });
            }
    }

    $('#locWhLocId').change(function() {
        var whLocId = $("#locWhLocId option:selected").val();
        if(whLocId == '') {
            AUIGrid.clearFilter(locGrid, "whLocId");
        } else {
            AUIGrid.setFilterByValues(locGrid, "whLocId", [whLocId]);
        }
    });

    $('#itemWhLocId').change(function() {
        var whLocId = $("#itemWhLocId option:selected").val();
        if(whLocId == '') {
            AUIGrid.clearFilter(itemGrid, "whLocId");
        } else {
            AUIGrid.setFilterByValues(itemGrid, "whLocId", [whLocId]);
        }
    });

    $('#historyYn').change(function() {
        var historyYn = $("#historyYn option:selected").val();

        if(historyYn == 'Y') {
	        AUIGrid.clearFilter(locGrid, "historyYn");
            AUIGrid.clearFilter(itemGrid, "historyYn");
        } else {
        	AUIGrid.setFilterByValues(locGrid, "historyYn", [historyYn]);
            AUIGrid.setFilterByValues(itemGrid, "historyYn", [historyYn]);
        }
    });

    $("#fileReupload").click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

    	var stockAuditNo = $("#hidStockAuditNo").val();
    	var data = {
                stockAuditNo: stockAuditNo
        };
    	Common.popupDiv("/logistics/adjustment/stockAuditReuploadPop.do", data, null, true, "stockAuditReuploadPop");
    	//Common.popupWin("frmNew", "/logistics/adjustment/stockAuditReuploadPop.do", {width : "1000px", height : "220", titlebar:"no", resizable: "no", scrollbars: "yes"});
    });

    $("#otherDetail").click(function(){

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

    	 var stockAuditNo = '${docInfo.stockAuditNo}';

    	 fn_stockAduitOtherPop(stockAuditNo, 'DET');
    });

    function fn_stockAduitOtherPop(stockAuditNo, action) {
        var data = {
                stockAuditNo: stockAuditNo,
                action: action,
        };

        Common.popupDiv("/logistics/adjustment/stockAuditOtherPop.do", data, null, true, "stockAuditOtherPop2");
    }

    function fn_reasonCodeSearch(){
        Common.ajax("GET", "/logistics/adjustment/selectOtherReasonCodeList.do",  {indVal : 'DED_RSN'}, function(result) {
            var temp    = { code : "", codeName : "" };
            dedRsnList.push(temp);
            otherGiRsnList.push(temp);
            otherGrRsnList.push(temp);
            for ( var i = 0 ; i < result.length ; i++ ) {
                if(result[i].ind == 'DED_RSN') {
                    dedRsnList.push(result[i]);
                } else if(result[i].ind == 'O_GI_RSN') {
                    otherGiRsnList.push(result[i]);
                }  else if(result[i].ind ==  'O_GR_RSN') {
                    otherGrRsnList.push(result[i]);
                }
            }
        }, null, {async : false});
    }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Stock Audit Detail</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2 <c:if test="${docInfo.docStusCodeId != '5683' && docInfo.docStusCodeId != '5684'}"> btn_disabled</c:if>"><a href="#" id="otherDetail">Other GI / GR Detail</a></p></li>
            <li><p class="btn_blue2 <c:if test="${docInfo.docStusCodeId != '5683' || docInfo.reuploadYn != 'Y'}"> btn_disabled</c:if>"><a href="#" id="fileReupload">File Reupload</a></p></li>
            <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
		<form id="frmNew" name="frmNew" action="#" method="post">
		      <input type="hidden" id="stockAuditNo" name="stockAuditNo" value="${docInfo.stockAuditNo}">
		</form>
        <form id="insertForm" name="insertForm">
            <input type="hidden" id="hidStockAuditNo" name="hidStockAuditNo" value="${docInfo.stockAuditNo}">
            <input type="hidden" id="hidWhLocId" name="hidWhLocId" value="${docInfo.whLocId}">
            <input type="hidden" id="hidLocType" name="hidLocType" value="${docInfo.locType}">
            <input type="hidden" id="hidItmType" name="hidItmType" value="${docInfo.itmType}">
            <input type="hidden" id="hidCtgryType" name="hidCtgryType" value="${docInfo.ctgryType}">

			  <table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:220px" />
				    <col style="width:140px" />
				    <col style="width:100px" />
				    <col style="width:140px" />
                    <col style="width:100px" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='log.head.stockauditno'/></th>
					    <td>${docInfo.stockAuditNo}</td>
					     <th scope="row"><spring:message code='log.head.docStatus'/></th>
					     <td colspan="3">${docInfo.docStusNm}</td>
					</tr>
					<tr>
                        <th scope="row"><spring:message code='log.head.stockAuditDate'/></th>
                        <td>${docInfo.docStartDt} ~ ${docInfo.docEndDt}</td>
					    <th scope="row"><spring:message code='log.head.locationgrade'/></th>
					    <td>${docInfo.locStkGrad}</td>
					    <th scope="row"><spring:message code='log.head.serialcheck'/></th>
                        <td>${docInfo.serialChkYn}</td>
				    </tr>
                    <tr>
                        <th scope="row"><spring:message code='log.head.locationtype'/></th>
                        <td id="eventtypetd"></td>
                        <th scope="row"><spring:message code='log.head.itemtype'/></th>
                        <td  colspan="3" id="itemtypetd"></td>
                    </tr>
				    <tr>
			            <th scope="row"><spring:message code='log.head.categoryType'/></th>
                        <td colspan="5" id="catagorytypetd"></td>
			        </tr>
			        <tr>
	                      <th scope="row"><spring:message code='log.head.stockAuditReason'/></th>
	                      <td colspan="5">${docInfo.stockAuditReason}</td>
	                 </tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.remark'/></th>
	                     <td colspan="5">${docInfo.rem}</td>
	                 </tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.createUserDate'/></th>
	                     <td>${docInfo.crtUserNm} / ${docInfo.crtDt}</td>
	                     <th scope="row"><spring:message code='log.head.modifyUserDate'/></th>
	                     <td colspan="3">${docInfo.updUserNm} / ${docInfo.updDt}</td>
	                 </tr>
				</tbody>
			</table>

        </form>

		<form id="appvForm" name="appvForm">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                     <tr>
                        <th scope="row"><spring:message code='log.head.groupwareAppAttFileReUpload'/></th>
                        <td colspan='3'>${docInfo.reuploadYn}</td>
                    </tr>
                    <tr>
	                    <th scope="row"><spring:message code='log.head.groupwareAppAttFile'/></th>
	                    <td colspan='3'>
                            <c:forEach var="fileInfo" items="${files}" varStatus="status">
                            <div class="auto_file4"><!-- auto_file start -->
                               <label>
                                   <input type='text' class='input_text' readonly='readonly' name="attachFile1"
                                          value="${fileInfo.atchFileName}" data-id="${fileInfo.atchFileId}"/>
                                   <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
                               </label>
                            </div>
                            </c:forEach>
	                    </td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdRequester'/></th>
                         <td>${docInfo.appv3ReqstUserNm}</td>
                         <th scope="row"><spring:message code='log.head.3rdRequestdate'/></th>
                         <td>${docInfo.appv3ReqstDt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdRequestapprovalOpinion'/></th>
                         <td colspan='3'>${docInfo.appv3ReqstOpinion}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdApprover'/></th>
                         <td>${docInfo.appv3UserNm}</td>
                         <th scope="row"><spring:message code='log.head.3rdApprovaldate'/></th>
                         <td>${docInfo.appv3Dt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdOpinion'/></th>
                         <td colspan='3'>${docInfo.appv3Opinion}</td>
                     </tr>
                </tbody>
            </table>
        </form>

		<section class="search_result"><!-- search_result start -->
            <ul class="right_btns">
               <li><select class="w50p" id="locWhLocId" name="locWhLocId"></select></li>
               <li>
                    <select class="w50p" id="historyYn" name="history">
                        <option value="N" selected>Except history</option>
                        <option value="Y">Include history</option>
                    </select>
               </li>
            </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="loc_grid_wrap_pop" style="width:100%; height:300px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

            <ul class="right_btns">
               <li><select class="w50p" id="itemWhLocId" name="itemWhLocId"></select></li>
               <li><p class="btn_grid"><a href="#" id="excelDownDet"><spring:message code='sys.btn.excel.dw'/></a></p></li>
            </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="item_grid_wrap_pop" style="width:100%; height:300px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->
        </section><!-- search_result end -->

    </section><!-- pop_body end -->
</div>
<!-- popup_wrap end -->
