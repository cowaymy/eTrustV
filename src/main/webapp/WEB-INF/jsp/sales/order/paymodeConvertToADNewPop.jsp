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

    $(document).ready(function(){
        setInputFile();
        creatGrid();
        $("#uploadGrid").hide();




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
            	console.log(event.target.result);
            	console.log(typeof event.target.result)
            	if(event.target.result ==  ',,,,,,,,,,,'){
            		console.log(typeof event.target.result)
            	}
                if (typeof event.target.result != "undefined") {
                    console.log("data : " + event.target.result);

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
            dataField : "custId",
            headerText : "Cust ID",
            width : 150
        },{
            dataField : "orderNo",
            headerText : "<spring:message code='sal.text.ordNo' />",
            width : 150
        },{
            dataField : "cardHolder",
            headerText : "Full Name",
            width : 100
        } ,{
            dataField : "contactStatus",
            headerText : "Status",
            width : 100
        } , {
            dataField : "failReason",
            headerText : "Fail reason",
            width : 100
        },{
            dataField : "payModeId",
            headerText : "Paymode Id",
            width : 100,
            visible : false
        },{
            dataField : "payModeName",
            headerText : "Paymode",
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
       },{
           dataField : "2",
           headerText : "tokenId",
           width : 100,
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
        console.log('checking');
        for (const key in data.all) {
		    if (data.all[key][0] == ''){
		        data.all.pop(key)
		        }
        }
        for (const key in data.all) {
            if (data.all[key][0] == ''){
                data.all.pop(key)
            }
        }
        Common.ajax("POST", "/payment/BatchConvertChecking.do", data, function(result)    {

            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
            AUIGrid.setGridData(cnvrListGrid, result);

            AUIGrid.setProp(cnvrListGrid, "rowStyleFunction", function(rowIndex, item) {
                if(item.payModeId != $("#payCnvrStusFrom").val()) {
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



    function fn_submit(){
        var data = GridCommon.getGridData(cnvrListGrid);
        data.form = $("#newCnvrForm").serializeJSON();

        var idx = AUIGrid.getRowCount(cnvrListGrid);
        var cnt = 0;
        for(var i=0; i < idx; i++){
            if(AUIGrid.getCellValue(cnvrListGrid, i, "chkSaveRow") == "N"){
                cnt++;
            }
        }
/*
        if(cnt > 0){
            Common.alert("There are "+cnt+"invalid item(s) in this conversion batch</br> Confirm conversion batch is disallowed.");
            return false;
        }



        if(idx == 0){
            Common.alert("No data to save.");
            return false;
        } */

        if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){

            Common.ajax("POST", "/payment/submitBatchTokenize.do",{}, function(result){

                //console.log("성공." + JSON.stringify(result));
                //console.log("data : " + result.data);

                Common.alert("<spring:message code='sal.alert.msg.newConversionBatchSuccessfully' />");       // 메시지 다시 만들어야함.
                fn_selfClose();

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
    function fn_selfClose() {
        // fn_selectListAjax();
        $('#_closeNew').click();
    }
    $(function(){
    $('#cnvrType').change(function(){
        $("#newCnvrRem").val('');
        $("#fileSelector").val('');
        $("#hiddenTotal").val('');
        AUIGrid.clearGridData(uploadGrid);
        AUIGrid.clearGridData(cnvrListGrid);


    });
    });

    function setInputFile(){//인풋파일 세팅하기
        $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
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

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<%-- <tr>
    <th scope="row">Conversion Type</th>
    <td>
    <select id="cnvrType" name="cnvrType" class="w100p">
        <option value="1">Sales Order</option>
        <option value="2">Rental Membership</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.statusConversion" /><span class="must">*</span></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p>
    <select class="w100p" id="payCnvrStusFrom" name="payCnvrStusFrom" >
        <option value="CRC">CRC</option>
        <option value="DD">DD</option>
        <option value="REG">REG</option>
    </select>
    </p>
    <span><spring:message code="sal.text.to" /></span>
    <p>
    <select class="w100p" id="payCnvrStusTo" name="payCnvrStusTo">
        <option value="CRC">CRC</option>
        <option value="DD">DD</option>
        <option value="REG">REG</option>
    </select>
    </p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td><textarea cols="20" rows="5" id="newCnvrRem" name="newCnvrRem" placeholder="Remark"></textarea></td>
</tr> --%>
            <tr>
                <th scope="row"><spring:message code="sal.text.selectYourCSVFile" /><span class="must">*</span></th>
                <td>

                     <div class="auto_file"><!-- auto_file start -->
                         <input type="file" title="file add"  id="fileSelector" name="fileSelector"/>
                     </div><!-- auto_file end -->
                     <p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/paymodeConversionRequest_Format.csv">Download CSV Format</a></p>
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
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_submit();"><spring:message code="sys.btn.submit" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_clearBtn"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->