<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.my-column-left {
        text-align: left;
    }

#textAreaWrap {
    font-size: 12px;
    position: absolute;
    height: 100px;
    min-width: 100px;
    background: #fff;
    border: 1px solid #555;
    display: none;
    padding: 4px;
    text-align: right;
    z-index: 9999;
}

#textAreaWrap textarea {
    font-size: 12px;
}

.editor_btn {
        background: #ccc;
        border: 1px solid #555;
        cursor: pointer;
        margin: 2px;
        padding: 2px;
    }
</style>

<script type="text/javaScript" language="javascript">

	var prdCtrlGridId;
	var chsCtrlGridId;
	var scoreRangeGridId;
    var keyValueList = [];

	var prdCtrlGridOptions = {
		editable : true,
		groupingFields : [ "stkCtgry" ],
		displayTreeOpen : true,
		enableCellMerge : true,
		cellMergeRowSpan : false,
		showBranchOnGrouping : false,
		headerHeight : 60,
	};

	var chsCtrlGridOptions = {
		editable : true,
		wordWrap : true,
		usePaging : true,
		rowHeight : '10%',
		headerHeight : 50,
	};

	var scoreRangeGridOptions = {
			groupingFields : [ "towerType" ],
			displayTreeOpen : true,
	        enableCellMerge : true,
	        showBranchOnGrouping : false,
	        editable : true,
	};

	var checkBoxOptions = {
		type : "CheckBoxEditRenderer",
		checkValue : 1,
		unCheckValue : 0,
		editable : true,
	};

	var gridDetailDataLength=0;

	$(document).ready(function() {
	    ccpFeedbackCode();
		chgTab();
	});

	function setPrdCtrlColumnLayout() {
		return [
				{
					dataField : "stkCtgry",
					headerText : "<spring:message code='sal.text.productCategory'/>",
					width : '15%'
				},
				{
					dataField : "stkId",
					visible : false
				},
				{
					dataField : "stkDesc",
					headerText : "<spring:message code='sal.text.productName'/>",
					width : '20%'
				},

				{
					headerText : "NEW CUSTOMER",
					children : [ {
						dataField : "highScore",
						headerText : "HIGH<br/>SCORE<br/><input type='checkbox' id='highScoreCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions,
					}, {
						dataField : "lowScore",
						headerText : "LOW<br/>SCORE<br/><input type='checkbox' id='lowScoreCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, {
						dataField : "noScoreNoccris",
						headerText : "NO SCORE<br/>NO CCRIS<br/><input type='checkbox' id='noScoreNoCcrisCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, {
						dataField : "noScoreInsuffCcris",
						headerText : "NO SCORE<br/>INSUFF. CCRIS<br/><input type='checkbox' id='noScoreInsuffCcrisCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, ],
				},
				{
					headerText : "EXISTING CUSTOMER",
					children : [ {
						dataField : "chsGreen",
						headerText : "CHS GREEN<br/><input type='checkbox' id='chsGreenCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, {
						dataField : "chsYellow",
						headerText : "CHS YELLOW<br/><input type='checkbox' id='chsYellowCb' style='width:15px;height:15px;''>",
						width : '9%',
						renderer : checkBoxOptions
					}, ],
				},
				{
                    dataField : "funcYn",
                    headerText : "TICK ALL/<br/>UNTICK ALL<br/><input type='checkbox' id='funcYnCb' style='width:15px;height:15px;''>",
                    renderer : {
                        type : "CheckBoxEditRenderer",
                        checkValue : 1,
                        unCheckValue : 0,
                        editable : true,
                         checkableFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

                            let checkedValue = !isChecked ? 1 : 0;

                            let checkItem = new Object();
                        	checkItem['highScore'] = checkedValue;
                            checkItem['lowScore'] = checkedValue;
                            checkItem['noScoreNoccris'] = checkedValue;
                            checkItem['noScoreInsuffCcris'] = checkedValue;
                            checkItem['chsGreen'] = checkedValue;
                            checkItem['chsYellow'] = checkedValue;

                            AUIGrid.updateRow(prdCtrlGridId, checkItem, rowIndex);

                            return true;
                        }
                    }
                }
				];
	}

	function setChsColumnLayout() {
        return [
                {
                    dataField : "remarkId",
                    visible : false
                },
                {
                    dataField : "chsRsn",
                    style : "my-column-left",
                    headerText : "<spring:message code='sal.text.reason'/>",
                    width : '10%'
                },
                {
                    dataField : "isAuto",
                    headerText : "Auto Score<br/><input type='checkbox' id='isAutoCb' style='width:15px;height:15px;''>",
                    width : '7%',
                    renderer : checkBoxOptions
                },
                {
                    dataField : "ccpRem",
                    headerText : "<spring:message code='sal.title.text.ccpRem'/>",
                    width : '60%',
                    style : "my-column-left",
                    renderer : {
                        type : "TemplateRenderer",
                    },
                    labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
                        let v = value.replace(/\n/g, '<br/>');
                        return v;
                    },
                    editRenderer: {
                        type: "InputEditRenderer",
                        showEditorBtnOver: true
                    },
                },
                {
                	dataField : "ccpResnId",
                	headerText : "<spring:message code='sal.title.text.ccpFeedbackCode' />",
                	width : '17%',
                	style : "my-column-left",
                	editable : true,
                	labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                		   let retStr = "";
                		   let selectedValue = value;
                		   $.each(keyValueList, function(index, value) {
                			   if(selectedValue == value.codeId){
                				   retStr = value.codeName;
                				   }
                			   });
                		   return retStr == "" ? value : retStr;
                    },
                	editRenderer : {
                	    type       : "DropDownListRenderer",
                        list       : keyValueList,
                        keyField   : "codeId",
                        valueField : "codeName"
                    }
                },
                {
                    dataField : "isHold",
                    headerText : "On Hold<br/><input type='checkbox' id='isHoldCb' style='width:15px;height:15px;''>",
                    width : '7%',
                    renderer : checkBoxOptions
                },

              ];
    }

	function setScoreRangeColumnLayout() {
        return [
                {
                    dataField : "scoreRangeId",
                    visible : false
                },
                {
                    dataField : "towerType",
                    headerText : " ",
                    width : '20%'
                },
                {
                    dataField : "scoreRangeType",
                    headerText : "Score Range Type",
                    width : '40%',
                    editable : false
                },
                {
                    dataField : "startScore",
                    headerText : "Start Score",
                    width : '20%',
                },
                {
                    dataField : "endScore",
                    headerText : "End Score",
                    width : '20%',
                },

                ];
    }

	function searchPrdCtrlAjax() {

		if(prdCtrlGridId != null ) AUIGrid.destroy(prdCtrlGridId);

		prdCtrlGridId = AUIGrid.create("#prdCtrl_grid",setPrdCtrlColumnLayout(), prdCtrlGridOptions);

		Common.ajax("GET", "/sales/ccp/selectProductControlList.do", "", function(data) {

			AUIGrid.bind(prdCtrlGridId, "headerClick", headerClickHandler);
			AUIGrid.setGridData(prdCtrlGridId, data);

			gridDetailDataLength = AUIGrid.getGridData(prdCtrlGridId).length;
		});
	}

	function searchChsCtrlAjax() {

		if(chsCtrlGridId != null ) AUIGrid.destroy(chsCtrlGridId);

		chsCtrlGridId = AUIGrid.create("#chsCtrl_grid",setChsColumnLayout(), chsCtrlGridOptions);

        Common.ajax("GET", "/sales/ccp/selectChsControlList.do", "", function(data) {

        	AUIGrid.bind(chsCtrlGridId, "headerClick", headerClickHandler);
            AUIGrid.setGridData(chsCtrlGridId, data);
            AUIGrid.resize(chsCtrlGridId);

            AUIGrid.bind(chsCtrlGridId, "cellEditBegin", function (event) {
            	if (event.which == "editorBtn")
            	    {createMyCustomEditRenderer(event);}
            	}
            );

            gridDetailDataLength = AUIGrid.getGridData(chsCtrlGridId).length;


            $("#confirmBtn").click(function (event) {
                let value = $("#chsCtrlTextarea").val();
                let selectedIndex = AUIGrid.getSelectedIndex(chsCtrlGridId)[0];

                AUIGrid.setCellValue(chsCtrlGridId, selectedIndex, "ccpRem", value);

                $("#textAreaWrap").hide();
            });

            $("#cancelBtn").click(function (event) {
                $("#textAreaWrap").hide();
            });
        });
    }

	function searchScoreRangeCtrlAjax() {
		if(scoreRangeGridId != null ) AUIGrid.destroy(scoreRangeGridId);

	    scoreRangeGridId = AUIGrid.create("#scoreRange_grid",setScoreRangeColumnLayout(), scoreRangeGridOptions);

		Common.ajax("GET", "/sales/ccp/selectScoreRangeControlList.do", "", function(data) {
			AUIGrid.setGridData(scoreRangeGridId, data);
		});
	}



	function headerClickHandler(event) {
		 let headerName = event.dataField;
		 let pid = event.pid;
		 let isChecked = !document.getElementById(event.orgEvent.target.id).checked;
		 for(idx = 0 ; idx < gridDetailDataLength ; idx++){
			 updateRows(pid,isChecked,headerName,idx);
		 }
	    return false;
	};

	function updateRows(pid, isChecked,name,rowIndex){
        let checkedValue = !isChecked ? 1 : 0;
        let checkItem = new Object();
        checkItem[name] = checkedValue;

        if(pid == "#prdCtrl_grid"){
        // Apply for Product Control Setting Tick All only
            if(name == 'funcYn'){
                checkItem['highScore'] = checkedValue;
                checkItem['lowScore'] = checkedValue;
                checkItem['noScoreNoccris'] = checkedValue;
                checkItem['noScoreInsuffCcris'] = checkedValue;
                checkItem['chsGreen'] = checkedValue;
                checkItem['chsYellow'] = checkedValue;
            }

            AUIGrid.updateRow(prdCtrlGridId, checkItem, rowIndex);
        }else{
        	AUIGrid.updateRow(chsCtrlGridId, checkItem, rowIndex);
        }
    }

    function fnUpdateCtrl(gridId)
    {
    	let url = "";1

        switch(gridId){
           case  prdCtrlGridId:
              url = "/sales/ccp/saveProductControl.do";
           break;
           case scoreRangeGridId :
              url = "/sales/ccp/saveScoreRangeControl.do";
           break;
           case  chsCtrlGridId:
              url = "/sales/ccp/saveChsControl.do";
           break;
        }

    	let updateList = AUIGrid.getEditedRowItems(gridId);
    	let data = {};
    	data.update = updateList;

    	if(data.update.length < 1){
    		Common.alert("No Changes");
    		return;
    	}

    	Common.ajax("POST", url , data , function(result){
    		Common.alert("Configuration saved", function() {
    			switch(gridId){
    	           case  prdCtrlGridId:
    	        	   chgTab('prdCtrl_info');
    	           break;
    	           case  scoreRangeGridId:
                       chgTab('scoreCtrl_info');
                   break;
    	           case  chsCtrlGridId:
    	        	   chgTab('chsCtrl_info');
    	           break;
    	        };

    		});
    	});
    }

    function createMyCustomEditRenderer(event) {

        var dataField = event.dataField;
        var $obj;
        var $textArea;

        if (dataField == "ccpRem") {
            $obj = $("#textAreaWrap").css({
                left: event.position.x,
                top: event.position.y,
                width: event.size.width - 100,
                height: 120
            }).show();
            $textArea = $("#chsCtrlTextarea").val(event.value);

            setTimeout(function () {
                $textArea.focus();
                $textArea.select();
            }, 16);
        }
    }

    function removeMyCustomEditRenderer(event) {
        $("#textAreaWrap").hide();
    }

    function chgTab(tabNm) {
    	switch(tabNm) {
        case 'prdCtrl_info' :
            searchPrdCtrlAjax();
        break;
        case 'scoreCtrl_info' :
        	searchScoreRangeCtrlAjax();
        break;
    	case 'chsCtrl_info' :
    	   searchChsCtrlAjax();
    	break;
        default :
        	searchPrdCtrlAjax();
        break;
    	}
    }

    async function ccpFeedbackCode(){
        const result = await fetch("/sales/ccp/selectReasonCodeFbList");
        keyValueList = await result.json();
        /* keyValueList[0] = {codeId:0,codeName :"Choose one"}; */
        keyValueList.unshift({ codeId: 0, codeName: "Choose one" });
    };

</script>
<section id="content">
    <ul class="path">
        <li><img
            src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
            alt="Home"
        /></li>
        <li><spring:message code='sales.path.sales' /></li>
        <li><spring:message code='sales.path.Promotion' /></li>
    </ul>
    <aside class="title_line">
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>
            <spring:message code='sales.title.ccpApprovalControl' />
        </h2>
        <ul class="right_btns"><li/></ul>
        <section class="tap_wrap">
            <!-- tap_wrap start -->
            <ul class="tap_type1">
                <li><a id="prdCtrl_info" href="#" class="on" onClick="chgTab(this.id)">Edit Product Control Setting</a></li>
                <li><a id="scoreCtrl_info" href="#" onClick="chgTab(this.id)">Edit Score Range</a></li>
                <li><a id="chsCtrl_info" href="#" onClick="chgTab(this.id)">Edit CHS Control Setting</a></li>
            </ul>

            <!-- PRODUCT CONTROL TAB -->
            <article class="tap_area" id="prdCtrl_info_div">
                 <ul class="right_btns" style="margin-bottom:10px">
                    <li><p class="btn_grid"><a onclick="fnUpdateCtrl(prdCtrlGridId);">SAVE</a></p></li>
                 </ul>
                <div id="prdCtrl_grid" style="height:70vh"/>
            </article>

            <!-- SCORE RANGE CONTROL TAB -->
            <article class="tap_area" id="scoreRange_info_div">
                <ul class="right_btns" style="margin-bottom:10px">
                    <li><p class="btn_grid"><a onclick="fnUpdateCtrl(scoreRangeGridId);">SAVE</a></p></li>
                 </ul>
                 <div class="divine_auto">
                     <div style="width:50%;">
                        <article class="grid_wrap">
                            <div id="scoreRange_grid" style="height:70vh;"/>
                        </article>
                     </div>
                 </div>
            </article>

            <!-- CHS CONTROL TAB -->
            <article class="tap_area" id="chs_info_div">
            <ul class="right_btns" style="margin-bottom:10px">
                    <li><p class="btn_grid"><a onclick="fnUpdateCtrl(chsCtrlGridId);">SAVE</a></p></li>
                 </ul>
                <div id="chsCtrl_grid" style="height:70vh"/>
            </article>
        </section>
        <!--  tab -->
        <!-- grid_wrap end -->

        <div id="textAreaWrap">
        <textarea id="chsCtrlTextarea" style="width:100%; height:90px;"></textarea>
            <ul class="right_btns" style="margin-top:4px;">
                <li><p class="btn_grid"><a id="confirmBtn">confirm</a></p></li>
                <li><p class="btn_grid"><a id="cancelBtn">cancel</a></p></li>
            </ul>
        </div>

</section>
</section>
</aside>
