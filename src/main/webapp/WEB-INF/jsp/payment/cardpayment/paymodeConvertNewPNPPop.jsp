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
<script type="text/javaScript">
var uploadGrid;
var cnvrListGrid;

let stusFrData = [ {"codeId" : "ALL", "codeName" : "All"}, {"codeId" : "PNP", "codeName" : "PNP RPS"}];
let stusToData = [ {"codeId" : "PNP", "codeName" : "PNP RPS"}, {"codeId" : "REG", "codeName" : "REG"}];

    $(document).ready(function(){
        setInputFile();
        creatGrid();
        $("#uploadGrid").hide();

        doDefCombo(stusFrData, '', 'payCnvrStusFrom', 'S', '');
        doDefCombo(stusToData, '', 'payCnvrStusTo', 'S', '');

        $('#fileSelector').on('change', function(evt) {

          if(fn_validCnvr()){
        	  var data = null;
              var file = evt.target.files[0];
              if (typeof file == "undefined") {
                  return;
              }

              var reader = new FileReader();
              reader.readAsText(file, "EUC-KR");
              reader.onload = function(event) {
                  if (typeof event.target.result != "undefined") {
                      console.log("data : " + event.target.result);
                      AUIGrid.setCsvGridData(uploadGrid, event.target.result, false);
                      AUIGrid.removeRow(uploadGrid,0);
                      fn_checkNewCnvr();

                  } else {
                      alert('No data to import!');
                  }
              };

              reader.onerror = function() {
                  alert('Unable to read ' + file.fileName);
              };

          }

          });

    });

    function creatGrid(){

        var upColLayout = [ {
            dataField : "0",
            headerText : "order no",
            width : 100
        },{
            dataField : "1",
            headerText : "remark",
            width : 100
        },{
            dataField : "2",
            headerText : "tokenId",
            width : 100
        }];

        var cnvrColLayout = [{
            dataField : "orderId",
            headerText : "Order id",
            visible : false
        },{
            dataField : "orderNo",
            headerText : "<spring:message code='sal.text.ordNo' />",
            width : "15%"
        },{
            dataField : "reason",
            headerText : "Reason",
            width : "25%"
        },{
            dataField : "cardNo",
            headerText : "Card No",
            width : "25%"
        },{
            dataField : "validRemark",
            headerText : "Valid Remark",
            width : "25%"
        /* },{
            dataField : "undefined",
            headerText : "Action",
            width : "10%",
            renderer : {
                  type : "ButtonRenderer",
                  labelText : "Remove",
                  onclick : function(rowIndex, columnIndex, value, item) {
                      AUIGrid.removeRow(cnvrListGrid, rowIndex);
                      AUIGrid.removeSoftRows(cnvrListGrid);
                  }
           } */
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

    function fn_checkNewCnvr(){
        var data = GridCommon.getGridData(uploadGrid);
        data.form = $("#newCnvrForm").serializeJSON();

        Common.ajax("POST", "/sales/order/chkPayCnvrListPnp", data, function(result)    {
            AUIGrid.setGridData(cnvrListGrid, result.data);
            AUIGrid.setProp(cnvrListGrid, "rowStyleFunction", function(rowIndex, item) {

            	if(item.validRemark) {
                    item.chkSaveRow = "N";

                    return "my-row-style";
                }

                return "";

            });


            AUIGrid.update(cnvrListGrid);
            $("#hiddenTotal").val(AUIGrid.getRowCount(cnvrListGrid));

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

    function fn_saveNewCnvr(){

    	if(fn_validCnvr()){
    		var data = GridCommon.getGridData(cnvrListGrid);
            data.form = $("#newCnvrForm").serializeJSON();

            if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){

                Common.ajax("POST", "/sales/order/savePayConvertListPnp", data, function(result){
                    Common.alert("<spring:message code='sal.alert.msg.newConversionBatchSuccessfully' />");       // 메시지 다시 만들어야함.

                    $("#newCnvrRem").val('');
                    $("#fileSelector").val('');
                    $("#hiddenTotal").val('');
                    AUIGrid.clearGridData(uploadGrid);
                    AUIGrid.clearGridData(cnvrListGrid);
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

    }

    $(function(){
        $('#cnvrType').change(function(){
        	$("#newCnvrForm").trigger("reset");
            AUIGrid.clearGridData(uploadGrid);
            AUIGrid.clearGridData(cnvrListGrid);
        });

        $('#_clearBtn').click(function(){
        	$('#cnvrType').change();
        });

    });

    function setInputFile(){
        $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
    }

    function fn_validCnvr(){
    	let valid = true, msg = "";

        if(!$("#payCnvrStusFrom option:selected").val()){
        	valid = false;
            msg += "* Please select Status(From)<br/>";
        }
    	if(!$("#payCnvrStusTo option:selected").val()){
    		valid = false;
            msg += "* Please select Status(To)<br/>";
    	}
    	if(!$("#newCnvrRem").val()){
            valid = false;
            msg += "* Please fill in remark<br/>";
        }


    	if (!valid) {
    		Common.alert(msg);

    		$("#newCnvrRem").val('');
            $("#fileSelector").val('');
            $("#hiddenTotal").val('');
            AUIGrid.clearGridData(uploadGrid);
            AUIGrid.clearGridData(cnvrListGrid);

    	}

    	console.log(valid);
    	return valid;


    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.newConversionBatch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_closeNew"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="newCnvrForm" name="newCnvrForm">
    <input id="hiddenTotal" name="hiddenTotal" type="hidden"/>
    <input id="hiddenIsPnp" name="hiddenIsPnp" type="hidden" value="1"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Conversion Type</th>
    <td>
    <select id="cnvrType" name="cnvrType" class="w100p" disabled>
        <option value="1">Sales Order</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.statusConversion" /><span class="must">*</span></th>
    <td>
    <div class="date_set">
        <p><select class="w100p" id="payCnvrStusFrom" name="payCnvrStusFrom" /></p>
            <span><spring:message code="sal.text.to" /></span>
        <p><select class="w100p" id="payCnvrStusTo" name="payCnvrStusTo" /></p>
    </div>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td><textarea cols="20" rows="5" id="newCnvrRem" name="newCnvrRem" placeholder="Remark"></textarea></td>
</tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.selectYourCSVFile" /><span class="must">*</span></th>
                <td>
                     <div class="auto_file">
                         <input type="file" title="file add"  id="fileSelector" name="fileSelector"/>
                     </div><!-- auto_file end -->
                     <p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/paymodeConversionRequest_Format.csv">Download CSV Format</a></p>
                </td>
            </tr>
            </tbody>
            </table>
<article class="grid_wrap">
    <div id="uploadGrid" style="width:100%; height:250px; margin:0 auto;"></div>
    <div id="cnvrListGrid" style="width:100%; height:250px; margin:0 auto;"></div>
</article>
</form>


<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_saveNewCnvr();"><spring:message code="sal.btn.save" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_clearBtn"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->