<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

     var uploadGrid;

    $(document).ready(function(){
    	setInputFile();    //file setting
    	creatGrid();
    	$("#uploadGrid").hide();
    	$("#searchOrdDt").hide();
    	$("#success_file1").hide();
    	$("#success_file2").hide();
    });
    
    function setInputFile(){//인풋파일 세팅하기
        $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
    }
    
    function creatGrid(){

        var upColLayout = [ {
            dataField : "0",
            headerText : "Order No",
            width : 100
        }];
        
        var cnvrColLayout = [ {
            dataField : "ordId",
            headerText : "Order Id",
            width : 90
        },{
            dataField : "ordNo",
            headerText : "Order No",
            width : 90
        },{
            dataField : "invReqRemark",
            headerText : "Remark"
        },{
            dataField : "invReqCreated",
            headerText : "Create At",
            dataType : "date",
            formatString : "dd/mm/yyyy" ,
            width : 130
        },{
            dataField : "invReqCreatorNm",
            headerText : "Create By",
            width : 100
        },{
            dataField : "invReqCreatorId",
            visible : false
        }];
        
        var upOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : true,
                   usePaging : false,
                   editable : false,
                   softRemoveRowMode:true
             }; 
        uploadGrid = GridCommon.createAUIGrid("#uploadGrid", upColLayout, "", upOptions);
        cnvrListGrid = GridCommon.createAUIGrid("#cnvrListGrid", cnvrColLayout, "", upOptions);
    }
    
  //**************************************************
    //** 업로드 파일 내용을 Grid에 적용하기
    //**************************************************
    // 파일 선택하기
    $('#readCSV').on('click', function(evt) {
    	var file= $('#fileSelector').get(0).files[0];
            var data = null;
          
     
         //   var file =  $('#fileSelector').files[0];
            if (typeof file == "undefined") {
            	alert("undefined");
                return;
            }
/*       $('#fileSelector').on('change', function(evt) {

             var data = null;
             var file = evt.target.files[0];
             if (typeof file == "undefined") {
                 return;
             } */
            var reader = new FileReader();
            //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                                        
                    // 그리드 CSV 데이터 적용시킴
                    AUIGrid.setCsvGridData(uploadGrid, event.target.result, false);
                    
                    //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
//                    AUIGrid.removeRow(uploadGrid,0);

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
        data.form = $("#singleForm").serializeJSON();

        Common.ajax("POST", "/sales/order/chkNewFileList", data, function(result)    {

        	console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
            
        	if(result.data.checkList != ""){
        		$("#searchOrdDt").show();
                $("#init_file").hide();
                $("#readCSV").hide();
                $("#success_file1").show();
                $("#success_file2").show();
                AUIGrid.setGridData(cnvrListGrid, result.data.checkList);
        	}
            
            if(result.data.regYN == "Y"){
                Common.alert(result.data.regMsg);
                return;
            }
            if(result.data.existYN == "Y"){
                Common.alert(result.data.existMsg);
                return;
            }

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
    
    function fn_saveBulk(){
    	var data = GridCommon.getGridData(cnvrListGrid);
        data.form = $("#singleForm").serializeJSON();
        
        var idx = AUIGrid.getRowCount(cnvrListGrid);
        
        if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){
        	
        	Common.ajax("POST", "/sales/order/saveNewFileList", data, function(result){

                console.log("성공." + JSON.stringify(result));
                console.log("data : " + result.data);
                
                Common.alert("Save successfully.", fn_finish);       // 메시지 다시 만들어야함.
              
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
    
    function fn_finish(){
    	$("#batchClose").click();
    	fn_orderInvestigationListAjax();
    }

</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Investigation Batch Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="batchClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="singleForm" name="singleForm" method="GET">
    <input type="hidden" id="salesOrdNo" name="salesOrdNo">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Select your CSV file<span class="must">*</span></th>
    <td>
    <div class="auto_file w100p"><!-- auto_file start -->
    <input type="file" id="fileSelector" title="file add" />
    </div><!-- auto_file end -->
    </td>
    <td>
        <p class="btn_sky"><a href="#" id="readCSV">Read CSV</a></p>
        <p class="btn_sky"><a id="init_file" href="${pageContext.request.contextPath}/resources/download/sales/ConversionRequest_Format.csv">Download CSV Format</a></p>
        <p class="btn_sky"><a href="#" id="success_file1" onclick="fn_saveBulk()">SAVE</a></p>
        <p class="btn_sky"><a href="#" id="success_file2" >Clear</a></p>
    </td>
</tr>
<!-- 
<tr>
    <th scope="row">Order No.</th>
    <td><input type="text" id="searchOrd" name="searchOrd" disabled="disabled" title="" placeholder="" class="" />
        <p class="btn_sky"><a href="#" id="searchBtn" onClick="fn_getNewReq()" disabled="disabled">Confirm</a></p>
        <p class="btn_sky"><a href="#" onClick="fn_orderNoExist2()">Clear</a></p>
    </td>
</tr>
 -->
</tbody>
</table><!-- table end -->

<div id="searchOrdDt">
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="uploadGrid" style="width:100%; height:250px; margin:0 auto;"></div>
    <div id="cnvrListGrid" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</div>
</form>
</section><!-- search_table end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->