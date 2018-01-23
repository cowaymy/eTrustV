<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript">

var uploadGrid;
var cnvrListGrid;

	$(document).ready(function(){
		setInputFile();
		creatGrid();
		$("#uploadGrid").hide();
		
		fn_changeCombo("REG");
		
	});
	
	function creatGrid(){

		var upColLayout = [ {
	        dataField : "0",
	        headerText : "order no",
	        width : 100
	    }];
		
	    var cnvrColLayout = [ {
	        dataField : "ordNo",
	        headerText : "Order No",
	        width : 150
	    },{
	        dataField : "ordStusCode",
	        headerText : "Order status",
	        width : 100
	    },{
	        dataField : "appTypeCode",
	        headerText : "App type",
	        width : 150
	    },{
	        dataField : "rentalStus",
	        headerText : "Rental status",
	        width : 100
	    },{
            dataField : "undefined",
            headerText : "Action",
            width : 170,
            renderer : {
                  type : "ButtonRenderer",
                  labelText : "Remove",
                  onclick : function(rowIndex, columnIndex, value, item) {
                	  AUIGrid.removeRow(cnvrListGrid, rowIndex);
                	  AUIGrid.removeSoftRows(cnvrListGrid);
                  }
           }
       },{
           dataField : "chkSaveRow",
           visible : false
       }];
	    
	    var upOptions = {
	               showStateColumn:false,
	               showRowNumColumn    : true,
	               usePaging : false,
	               editable : false,
	               softRemoveRowMode:false
	         }; 
	    
	    uploadGrid = GridCommon.createAUIGrid("#uploadGrid", upColLayout, "", upOptions);
	    cnvrListGrid = GridCommon.createAUIGrid("#cnvrListGrid", cnvrColLayout, "", upOptions);
	}
	
	//**************************************************
    //** 업로드 파일 내용을 Grid에 적용하기
    //**************************************************
    // 파일 선택하기
    $('#fileSelector').on('change', function(evt) {

            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                return;
            }
            
            var reader = new FileReader();
            //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                                        
                    // 그리드 CSV 데이터 적용시킴
                    AUIGrid.setCsvGridData(uploadGrid, event.target.result, false);
                    
                    //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(uploadGrid,0);
                    
                    fn_checkNewCnvr();
                    
                } else {
                    alert('No data to import!');
                }
            };

            reader.onerror = function() {
                alert('Unable to read ' + file.fileName);
            };

    });
	
    function fn_checkNewCnvr(){
        var data = GridCommon.getGridData(uploadGrid);
        data.form = $("#newCnvrForm").serializeJSON();

        Common.ajax("POST", "/sales/order/chkNewCnvrList", data, function(result)    {


            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);              
                                    
            AUIGrid.setGridData(cnvrListGrid, result.data);
                    
            AUIGrid.setProp(cnvrListGrid, "rowStyleFunction", function(rowIndex, item) {
                if(item.rentalStus != $("#pRsCnvrStusFrom").val()) { 
                	item.chkSaveRow = "N";
                    return "my-row-style";
                }
                if(item.appTypeCode != 'REN'){
                	item.chkSaveRow = "N";
                	return "my-row-style";
                }
                return "";

            }); 

            // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
            AUIGrid.update(cnvrListGrid);
                    
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
                      alert("Fail : " + jqXHR.responseJSON.message);
         });

    }
	
	function setInputFile(){//인풋파일 세팅하기
		$(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
	}

	function fn_changeCombo(value){
	    
	    var targetObj = document.getElementById("pRsCnvrStusTo");
	    
	    for (var i = targetObj.length - 1; i >= 0; i--) {
	        targetObj.remove(i);
	    }
	    
	    if(value=="REG"){
	        $('<option />', { value: "INV", text: "Investigate"}).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
	        $('<option />', {value: "SUS", text: "Suspend" }).appendTo($("#pRsCnvrStusTo"));
	        $('<option />', {value: "RET", text: "Return" }).appendTo($("#pRsCnvrStusTo"));
	        $('<option />', {value: "WOF", text: "Write Off" }).appendTo($("#pRsCnvrStusTo"));
	    }else if(value=="INV"){
	        $('<option />', { value: "REG", text: "Regular" }).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
	        $('<option />', {value: "SUS", text: "Suspend" }).appendTo($("#pRsCnvrStusTo"));
	        $('<option />', {value: "RET", text: "Return" }).appendTo($("#pRsCnvrStusTo"));
            $('<option />', {value: "WOF", text: "Write Off" }).appendTo($("#pRsCnvrStusTo"));
	    }else if(value=="SUS"){
	        $('<option />', {value: "REG", text: "Regular"}).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
	        $('<option />', {value: "INV", text: "Investigate"}).appendTo($("#pRsCnvrStusTo"));
	        $('<option />', {value: "RET", text: "Return" }).appendTo($("#pRsCnvrStusTo"));
            $('<option />', {value: "WOF", text: "Write Off" }).appendTo($("#pRsCnvrStusTo"));
	    }else if(value=="RET"){
	    	$('<option />', {value: "REG", text: "Regular"}).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
            $('<option />', {value: "INV", text: "Investigate"}).appendTo($("#pRsCnvrStusTo"));
            $('<option />', {value: "SUS", text: "Suspend" }).appendTo($("#pRsCnvrStusTo"));
            $('<option />', {value: "WOF", text: "Write Off" }).appendTo($("#pRsCnvrStusTo"));
	    }else if(value=="TER"){
	        $('<option />', { value: "WOF", text: "Write Off"}).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
	    }
	}
	
	function fn_saveNewCnvr(){
	    var data = GridCommon.getGridData(cnvrListGrid);
	    data.form = $("#newCnvrForm").serializeJSON();

	    var idx = AUIGrid.getRowCount(cnvrListGrid);
	    var cnt = 0;
	    var rsCnvrFeesApplyChk = 0;
	    for(var i=0; i < idx; i++){     
	        if(AUIGrid.getCellValue(cnvrListGrid, i, "chkSaveRow") == "N"){
	            cnt++;
	        }           
	    }
	    
	    if(cnt > 0){
	    	//Common.alert("There are "+cnt+"invalid item(s) in this conversion batch</br> Confirm conversion batch is disallowed.");
	    	alert($('input:checkbox[id="rsCnvrReactFeesApply"]').is(":checked"));
	    	return false;
	    }

	    if(idx == 0){
            Common.alert("No data to save.");
            return false;
        }

	    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){         
	            
	        Common.ajax("POST", "/sales/order/saveNewConvertList", data, function(result){

	            console.log("성공." + JSON.stringify(result));
	            console.log("data : " + result.data);
	            
	            Common.alert("New conversion batch successfully saved.", fn_end);       // 메시지 다시 만들어야함.
	          
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
	            alert("Fail : " + jqXHR.responseJSON.message);
	        });

	    }));
	}
	
	function fn_end(){
		$("#_closeNew").click();
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>NEW CONVERSION BATCH</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_closeNew">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="newCnvrForm" name="newCnvrForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status Conversion<span class="must">*</span></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p>
    <select class="w100p" id="pRsCnvrStusFrom" name="pRsCnvrStusFrom" onchange="javascript:fn_changeCombo(this.value);">
        <option value="REG">Regular</option>
        <option value="INV">Investigate</option>
        <option value="SUS">Suspend</option>
        <option value="RET">Return</option>
        <option value="TER">Terminate</option>
    </select>
    </p>
    <span>to</span>
    <p>
    <select class="w100p" id="pRsCnvrStusTo" name="pRsCnvrStusTo">
    </select>
    </p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td><textarea cols="20" rows="5" id="newCnvrRem" name="newCnvrRem" placeholder="Remark"></textarea></td>
</tr>
<tr>
    <td colspan="2">
    <label><input type="checkbox" id="rsCnvrReactFeesApply" name="rsCnvrReactFeesApply" value="1" checked/><span>Reactive Fees Apply ?</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Select your CSV file<span class="must">*</span></th>
    <td>
    <div class="auto_file"><!-- auto_file start -->
    <input type="file" id="fileSelector" title="file add" />
    </div><!-- auto_file end -->
<!--     <p class="btn_sky"><a href="#" onclick="fn_readFile();">Read CSV</a></p> -->
    <p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/orderConversionRequest_Format.csv">Download CSV Format</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="uploadGrid" style="width:100%; height:250px; margin:0 auto;"></div>
    <div id="cnvrListGrid" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_saveNewCnvr();">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_clearBtn">CLEAR</a></p></li>
</ul>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->