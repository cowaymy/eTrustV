<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">
    //AUIGrid 그리드 객체
    var mySurveyGridID;

    var keyValueList = [];
    var ans7360List = [{codeId : "No,Yes", codeName : "No,Yes"},{codeId : "Yes,No", codeName : "Yes,No"}];
    var ans7361List = [{codeId : "1,5", codeName : "1,5"}];
    var ans7362List = [];

    //Grid Properties 설정
    var gridPros = {
            usePaging : false,
            useGroupingPanel : false,
            showRowNumColumn : false, // 순번 칼럼 숨김
            showStateColumn : true,
            softRemovePolicy : "exceptNew",
            softRemoveRowMode : false
    };

    // AUIGrid 칼럼 설정
    var surveyColumnLayout = [
		 {
			   dataField : "survSeq",
		       headerText : 'No.',
		       dataType: "numeric",
		       expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
		              // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
		              return rowIndex + 1;
		          }
	     },
        {dataField : "survQues1",headerText : "Survey Question", width : 700,style : "aui-grid-left-column"},
        {dataField : "codeId",headerText : "Description",width : 100,
        	 labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                 var retStr = value;
                 for(var i=0,len=keyValueList.length; i<len; i++) {
                     if(keyValueList[i]["codeId"] == value) {
                         retStr = keyValueList[i]["codeName"];
                         break;
                     }
                 }
                 return retStr;
             },
             editRenderer :
            {
                type : "ComboBoxRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                list : keyValueList, //key-value Object 로 구성된 리스트
                keyField : "codeId", // key 에 해당되는 필드명
                valueField : "codeName", // value 에 해당되는 필드명
                descendants : ["tmplAns"],
                descendantDefaultValues: []
             }
        },
        {dataField : "tmplAns",headerText : "Answer Sequence",width : 130 ,
			editRenderer :
			{
				type : "ComboBoxRenderer",
				showEditorBtnOver : true,
	            listFunction : function(rowIndex, columnIndex, item,dataField){
	            	if(item.codeId == "7360"){
	            		return ans7360List;
	            	}else if (item.codeId == "7361"){
	            		return ans7361List;
	            	}else{
	            		return ans7362List;
	            	}
	            },
				keyField : "codeId", // key 에 해당되는 필드명
				valueField : "codeName", // value 에 해당되는 필드명
			}
        },
        {dataField : "survQuesYn",headerText : "Use YN",width : 100 ,
        	editRenderer :
	        {
	            type : "ComboBoxRenderer",
	            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
	            listFunction : function(rowIndex, columnIndex, item, dataField) {
	               var list = getDisibledComboList();
	               return list;
	            },
	            keyField : "id"
	         }
        }
    ];


    $(document).ready(function(){
        searchData();
        mySurveyGridID = GridCommon.createAUIGrid("grid_survey_wrap", surveyColumnLayout, null, gridPros);

        getDescComboList();

    });

    function searchData(){
        Common.ajax("POST","/misc/chatbotSurveyMgmt/selectChatbotSurveyMgmtEdit.do", {ctrlId : $("#ctrlId").val(), ctrlType : $("#ctrlType").val(), survGrpId : $("#survGrpId").val()}, function(result){
        	AUIGrid.setGridData(mySurveyGridID, result);

        	 if(result[0].survStus == 8){
                 $("#btn_save").hide();
                 $("#btn_add").hide();
             }
        });
    }

    function getDisibledComboList(){
	      var list =  ["N", "Y"];
	      return list;
    }

    function getDescComboList(){
        Common.ajax("GET", "/misc/chatbotSurveyMgmt/selectChatbotSurveyDesc",  null, function(result) {
            var temp    = { codeId : "", codeName : "" };
            keyValueList.push(temp);
            for ( var i = 0 ; i < result.length ; i++ ) {
                keyValueList.push(result[i]);
            }
        }, null, {async : false});
    }

    function getAnsComboList(tmplType){
    	var keyValueAnsList2 = [];
    	if(tmplType == "7360"){
	    	keyValueAnsList2.push({codeId : "No,Yes", codeName : "No,Yes"});
	    	keyValueAnsList2.push({codeId : "Yes,No", codeName : "Yes,No"});
    	}else if(tmplType == "7361"){
    		keyValueAnsList2.push({codeId : "1,5", codeName : "1,5"});
    	}

    	return keyValueAnsList2;
    }

    function fn_addRow(){
    	var item = new Object();

        item.survSeq = "";
        item.survQues1 ="";
        item.codeName = "" ;
        item.codeId  ="";
        item.tmplAns ="";
        item.survQuesYn ="";
        // parameter
        // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(mySurveyGridID, item, "last");
    }


    function fn_save(){
   	  if (fn_validation() == false){
   	    return false;
   	  }

		var data = {
				all : AUIGrid.getGridData(mySurveyGridID),
				id : $("#ctrlId").val(),
				ctrlType : $("#ctrlType").val(),
				survGrpId : $("#survGrpId").val()
		};

		Common.ajax("POST", "/misc/chatbotSurveyMgmt/saveSurveyDetail.do", data, function(result){
			if(result.message == "success."){
				Common.alert("Survey questions have been updated successfully.");
				$("#_chatbotSurveyMgmtListEditPop").remove();
				searchList();
			}

		});
    }

    function fn_validation(){
    	 var checkResult = true;
    	 var length = AUIGrid.getGridData(mySurveyGridID).length;

         if(length > 0) {
             for(var i = 0; i < length; i++) {
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(mySurveyGridID, i, "survQues1"))) {
                     Common.alert('Please enter the survey question of line ' + (i +1) + ".");
                     checkResult = false;
                     return checkResult;
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(mySurveyGridID, i, "codeId"))) {
                     Common.alert('Please enter the description of line ' + (i +1) + ".");
                     checkResult = false;
                     return checkResult;
                 }
                 if((AUIGrid.getCellValue(mySurveyGridID, i, "codeId") != "7362")) {
                	 if(FormUtil.isEmpty(AUIGrid.getCellValue(mySurveyGridID, i, "tmplAns"))) {
                         Common.alert('Please enter the answer sequence of line ' + (i +1) + ".");
                         checkResult = false;
                         return checkResult;
                     }
                 }
                 if(FormUtil.isEmpty(AUIGrid.getCellValue(mySurveyGridID, i, "survQuesYn")) ) {
                     Common.alert('Please enter use YN for detail line' + (i +1) + ".");
                     checkResult = false;
                     return checkResult;
                 }
             }
         }else{
        	 Common.alert("No survey question submitted.");
        	 checkResult = false;
             return checkResult;
         }
    }
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1 id="headerLbl">Survey Management Edit</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
        <!-- grid_wrap start -->
        <article class="grid_wrap">
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
                        <th scope="row">Survey Type</th>
                        <td>
                            <input id="surveyTypeEdit" name="surveyTypeEdit" type="text" class="readonly" readonly  style="width: 100%;" value="${ctrlRem}"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </article>

        <ul class="right_btns">
		    <li><p class="btn_grid" id="btn_add"><a onclick="fn_addRow();">Add</a></p></li>
		</ul>

        <article class="grid_wrap">
            <div id="grid_survey_wrap" style="width: 100%; height: 400px; margin: 0 auto;"></div>
        </article>
        <!-- grid_wrap end -->

        <section class="search_table">
               <form name="_surveySearchForm" id="_surveySearchForm"  method="post">
                <input id="ctrlId" name="ctrlId" value="${ctrlId}" type="hidden" />
                <input id="ctrlType" name="ctrlType" value="${ctrlType}" type="hidden" />
                <input id="survGrpId" name="survGrpId" value="${survGrpId}" type="hidden" />
            </form>
        </section>

        <ul class="center_btns">
            <li><p class="btn_blue" id="btn_save"><a href="javascript:fn_save();">SAVE</a></p></li>
        </ul>
    </section>
</div>