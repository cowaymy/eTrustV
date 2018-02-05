<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.my-left-style {
    text-align:left;
}
.aui-grid-drop-list-ul {
   text-align:left;
}
</style>
<script  type="text/javascript">
var trReBookGridID;
/* var detailList; */
var feedBackList;

$(document).ready(function(){
    
   /*  if('${detailList}'=='' || '${detailList}' == null){
    }else{
        detailList = JSON.parse('${detailList}');         
        console.log(detailList);
    }  */ 
    
    feedBackList =  JSON.parse('${feedBackList}');       

	creatTrReBookGrid();
	
	fn_selectReBookListAjax();
     
});

//리스트 조회.
function fn_selectReBookListAjax() {
    
  Common.ajax("GET", "/sales/trBook/selectTrBookRetrun", $("#updateTrForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(trReBookGridID, result.detailList);
      
      $("#totalMatch").html(result.resultData.totalMatch);
      $("#totalUnmatch").html(result.resultData.totalUnmatch);
      $("#totalCancel").html(result.resultData.totalCancel);
      $("#totalLost").html(result.resultData.totalLost);
      
      if( parseInt(result.resultData.totalLost) > 0){
    	  $("#trTrnsitStusId").val("68");
      }else{
          $("#trTrnsitStusId").val("36");
      }
      
      $("#totalFinance").html(result.resultData.totalFinance);
      $("#totalMarketing").html(result.resultData.totalMarketing);

  });
}

function creatTrReBookGrid(){

    var keyValueList = [{"code":"0", "value":"Return TR"}, {"code":"10", "value":"Cancel TR"}, {"code":"67", "value":"Report Lost"}, {"code":"70", "value":"Used by Finance"}, {"code":"72", "value":"Used by Marketing"}];
    var trReBookColLayout = [ 
          {dataField : "trBookItmId", headerText : "", width : 140  , visible:false  },
          {dataField : "itmUnderDcf", headerText : "", width : 140  , visible:false  },
          {dataField : "trReciptNo", headerText : "<spring:message code="sal.title.receiptNo" />", width : 140    },
          {dataField : "action", headerText : "<spring:message code="sal.title.action" />", width : 140 , editable : true,
        	   labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                  var retStr = "";
                  for(var i=0,len=keyValueList.length; i<len; i++) {
                      if(keyValueList[i]["code"] == value) {
                          retStr = keyValueList[i]["value"];
                          break;
                      }
                  }
                              return retStr == "" ? value : retStr;
              }, 
              editRenderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                     type : "DropDownListRenderer",
                     list : keyValueList,
                     keyField   : "code", // key 에 해당되는 필드명
                     valueField : "value" // value 에 해당되는 필드명
               }
		  },
          {dataField : "feedback", headerText : "<spring:message code="sal.title.feedbackCode" />", width : 200, editable:true, style:"aui-grid-drop-list-ul" ,
			  labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                  var retStr = "<spring:message code="sal.title.feedbackCode" />";
                  for(var i=0,len=feedBackList.length; i<len; i++) {
                      if(feedBackList[i]["resnId"] == value) {
                          retStr = feedBackList[i]["value"];
                          break;
                      }
                  }
                              return retStr == "" ? value : retStr;
              }, 
              editRenderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                     type : "DropDownListRenderer",
                     list : feedBackList,
                     keyField   : "resnId", // key 에 해당되는 필드명
                     valueField : "value" // value 에 해당되는 필드명
               }
		  },
          {dataField : "remark", headerText : "<spring:message code="sal.title.remark" />", width : 350  ,   style:"my-left-style" }  ,        
          {dataField : "", headerText : "", width : 80,
        	  renderer : {
                  type : "ButtonRenderer",
                  labelText : "<spring:message code="sal.btn.Go" />",
                  onclick : function(rowIndex, columnIndex, value, item) {
                      $("#trItemId").val(AUIGrid.getCellValue(trReBookGridID, rowIndex, "trBookItmId"));
                      $("#itmUnderDcf").val(AUIGrid.getCellValue(trReBookGridID, rowIndex, "itmUnderDcf"));
                      
                      if($("#itmUnderDcf").val() =="1"){
                    	  Common.alert("<spring:message code="sal.alert.title.actionRestriction" />"  + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.underDCF" />.<br /><spring:message code="sal.alert.msg.noOtherAction" />");
                          return ;
                      }else{
                    	  fn_goAction(AUIGrid.getCellValue(trReBookGridID, rowIndex, "action"), rowIndex);
                      }
                      
                  }
        	  }
          }          
          ];
    

    var trReBookOptions = {
               showStateColumn:false,
               showRowNumColumn    : true,
               usePaging : true,
               editable : true
               //selectionMode : "singleRow"
         }; 
    
    trReBookGridID = GridCommon.createAUIGrid("#trReBookGridID", trReBookColLayout, "", trReBookOptions);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(trReBookGridID, "cellEditBegin", auiCellEditignHandler);
    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(trReBookGridID, "cellEditEnd", auiCellEditignHandler);
    
      // 셀 클릭 이벤트 바인딩
     AUIGrid.bind(trReBookGridID, "cellClick", function(event){
    	 
    	$("#trBookItmId").val(AUIGrid.getCellValue(trReBookGridID, event.rowIndex, "trBookItmId"));
              
     });      
   
}

//AUIGrid 메소드
function auiCellEditignHandler(event)
{
    if(event.type == "cellEditBegin")
    {
        console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 9);
        
        if(event.dataField == "feedback")
        {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.getCellValue(trReBookGridID, event.rowIndex, "action")=='67'){  //추가된 Row
                return true; 
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
        if(event.dataField == "remark")
        {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.getCellValue(trReBookGridID, event.rowIndex, "action")=='67'){  //추가된 Row
                return true; 
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
    }else  if(event.type == "cellEditEnd"){
    	if(event.dataField == "action")
        {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.getCellValue(trReBookGridID, event.rowIndex, "action")!='67' ){
            	AUIGrid.setCellValue(trReBookGridID, event.rowIndex, "remark", "");
            	AUIGrid.setCellValue(trReBookGridID, event.rowIndex, "feedback", "");
            }  
        }
    }
}

function fn_goAction(str, rowIndex){

    $("#trStusId").val(str);
    AUIGrid.forceEditingComplete(trReBookGridID, null, false);
	
	switch (str)
    {
        case "10":
            //TO CANCEL
            Common.confirm("<spring:message code="sal.alert.title.actionConfirmation" />"  + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.actionConfirmation" />", function(){
            	fn_updateReTrBook("Cancel");
            });
            break;
        case "67":
            if (fn_validRequiredField(rowIndex))
            {
            	Common.confirm("<spring:message code="sal.alert.title.actionConfirmation" />"+ DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.actionConfirmation2" />", function(){
            	
                    $("#trReFeedback").val(AUIGrid.getCellValue(trReBookGridID, rowIndex, "feedback"));
                    $("#trReRemark").val(AUIGrid.getCellValue(trReBookGridID, rowIndex, "remark"));
                    $("#trReTrReciptNo").val(AUIGrid.getCellValue(trReBookGridID, rowIndex, "trReciptNo"));
            		
                    Common.popupDiv("/sales/trBook/fileUploadPop.do",$("#updateTrForm").serializeJSON(), null, true, "fileUploadPop");
            		
            	});
            	
            }
            break;
        case "70":
            //USED BY FINANCE
             Common.confirm("<spring:message code="sal.alert.title.actionConfirmation" />"  + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.actionConfirmation3" />", function(){
            	 fn_updateReTrBook("Set As Finance Use");
            });
           break;
        case "72":
            //USED BY MARKETING
             Common.confirm("<spring:message code="sal.alert.title.actionConfirmation" />"  + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.actionConfirmation4" />", function(){
            	 fn_updateReTrBook("Set As Marketing Use");
            });
            break;
        default:
            break;
    }
	
}

function fn_updateReTrBook(actionStr){
	
    // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
    AUIGrid.forceEditingComplete(trReBookGridID, null, false);	
		
	Common.ajax("POST", "/sales/trBook/updateReTrBook", $("#updateTrForm").serializeJSON(), function(result)    {
        //fn_selectPopListAjax() ;

        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.cnt);

        Common.alert("<spring:message code="sal.alert.title.itemSuccessfully" /> " + actionStr + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.itemSuccessfully" /> " + actionStr + ".");

        fn_selectReBookListAjax();
     }
     , function(jqXHR, textStatus, errorThrown){
            try {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          }
          catch (e)
          {
            console.log(e);
          }
          Common.alert("<spring:message code="sal.alert.title.failTo" /> " + actionStr + DEFAULT_DELIMITER + "<spring:message code="sal.alert.title.failTo" /> " + actionStr + " <spring:message code="sal.alert.msg.failItem" />");
    });
	
}

function fn_returnSave(){	

    var idx = AUIGrid.getRowCount("trReBookGridID");
	
	if(fn_validReturnTR(idx)){
		if(idx > 0){
			Common.alert('<spring:message code="sal.alert.msg.returnSaveRestrict" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.unmatchItemFound" />');
		}else{			
			
			Common.ajax("POST", "/sales/trBook/saveReTrBook", $("#updateTrForm").serializeJSON(), function(result)    {
		        //fn_selectPopListAjax() ;

		        console.log("성공." + JSON.stringify(result));
		        console.log("data : " + result.reqNo);

//		        Common.alert('<spring:message code="sal.alert.msg.itemSuccessfully" />' + DEFAULT_DELIMITER + "Return successfully saved. <br />TR book has been returned to [" + result.reqNo + "].");
		        Common.alert('<spring:message code="sal.alert.msg.itemSuccessfully" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.rtnSuccSaveTrRtn" arguments="'+result.reqNo+'"/>');

		        fn_selectReBookListAjax();
		        $("#btnReturnSave").hide();
		        fn_selectListAjax();
		     }
		     , function(jqXHR, textStatus, errorThrown){
		            try {
		                console.log("Fail Status : " + jqXHR.status);
		                console.log("code : "        + jqXHR.responseJSON.code);
		                console.log("message : "     + jqXHR.responseJSON.message);
		                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
		          }
		          catch (e)
		          {
		            console.log(e);
		          }
		          Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.failToSaveReturnTryAgain" />');
		    });
		
		}
		
	}else{
		Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.fatilToSaveReturnSeleTr" />');
	}
	
	
}

function fn_validReturnTR(idx) {
	
    var success = false;
    
    if(idx != 0){
        for(var i = 0; i < idx; i++){
            if(AUIGrid.getCellValue(trReBookGridID, i, "action") !="0")
                return false;
            else
            	success = true;
        }
        
    }else{
    	success = true;
    }
    return success;
}

function fn_validRequiredField(rowIndex)
{
    var valid = true;
    var message = "";
    
    if (AUIGrid.getCellValue( trReBookGridID, rowIndex , "feedback") == "")
    {
        valid = false;
        message += '<spring:message code="sal.alert.msg.selTheFeedbackCode" />';
    }
    if (AUIGrid.getCellValue( trReBookGridID, rowIndex , "remark") == "")
    {
        valid = false;
        message += '<spring:message code="sal.alert.msg.plzKeyInRemarks" />';
    }
    if (!valid)
    {
    	Common.alert(message);
    }

    return valid;
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.trBookMgmtRtn" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.trBookDetails" /></h2>
</aside><!-- title_line end -->
<form action="#" method="post" id="updateTrForm" name="updateTrForm">
<input type="hidden" id="trReBookId" name="trReBookId" value="${trBookId}">
<input type="hidden" id="trBookItmId" name="trBookItmId">
<input type="hidden" id="itmUnderDcf" name="itmUnderDcf">
<input type="hidden" id="trStusId" name="trStusId">
<input type="hidden" id="trReHolder" name="trReHolder" value="${trBookInfo.trHolder}">
<input type="hidden" id="trReMemCode" name="trReMemCode" value="${memberInfo.memCode}">
<input type="hidden" id="trTrnsitStusId" name="trTrnsitStusId">

<input type="hidden" id="trReFeedback" name="trReFeedback">
<input type="hidden" id="trReRemark" name="trReRemark">
<input type="hidden" id="trReTrReciptNo" name="trReTrReciptNo">
<input type="hidden" id="trReTrBookNo" name="trReTrBookNo" value ="${trBookInfo.trBookNo}">

</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.title.text.trBookNo" /></th>
	<td>${trBookInfo.trBookNo}</td>
	<th scope="row"><spring:message code="sal.text.prefixNo" /></th>
	<td>${trBookInfo.trBookPrefix}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.trNo" /></th>
	<td>${trBookInfo.trBookNoStart} To ${trBookInfo.trBookNoEnd}</td>
	<th scope="row"><spring:message code="sal.title.text.trHolder" /></th>
	<td>${trBookInfo.trHolder}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.status" /></th>
	<td>${trBookInfo.trBookStusCode}</td>
	<th scope="row"><spring:message code="sal.title.text.totPages" /></th>
	<td>${trBookInfo.trBookPge}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.returnTo" /></th>
	<td colspan="3">${branch} - ${branchName}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.totalMatch" /></th>
	<td><span id="totalMatch"></span></td>
	<th scope="row"><spring:message code="sal.title.text.totUnmatch" /></th>
	<td><span id="totalUnmatch"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.totCancel" /></th>
	<td><span id="totalCancel"></span></td>
	<th scope="row"><spring:message code="sal.title.text.totLost" /></th>
	<td><span id="totalLost"></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.text.totFinanceUsed" /></th>
	<td><span id="totalFinance"></span></td>
	<th scope="row"><spring:message code="sal.title.text.totMarketingUsed" /></th>
	<td><span id="totalMarketing"></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.holderInformation" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.memberCode" /></th>
	<td>${memberInfo.memCode}</td>
	<th scope="row"><spring:message code="sal.text.memtype" /></th>
	<td>${memberInfo.memType}</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.title.memberName" /></th>
	<td>${memberInfo.memName}</td>
	<th scope="row"><spring:message code="sal.text.nric" /></th>
	<td>${memberInfo.memNric}</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.unmatchReceipt" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="trReBookGridID" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="btnReturnSave" onclick="javascript:fn_returnSave();"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
