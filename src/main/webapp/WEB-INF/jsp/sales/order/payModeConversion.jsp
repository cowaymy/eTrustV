<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    var newGridID;

    $(document).ready(function(){
        //setInputFile();
        creatGrid();
        $("#uploadGrid").hide();
        $("#cnvrListGrid").hide();



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
        }];

        var cnvrColLayout = [{
            dataField : "orderId",
            headerText : "order id",
            width : 150
        },{
            dataField : "orderNo",
            headerText : "<spring:message code='sal.text.ordNo' />",
            width : 150
        },{
            dataField : "srvCntrctId",
            headerText : "Contract id",
            width : 100
        },{
            dataField : "srvCntrctRefNo",
            headerText : "Contract No",
            width : 100
        },{
            dataField : "reason",
            headerText : "reason",
            width : 100
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

        Common.ajax("POST", "/sales/order/chkPayCnvrList", data, function(result)    {


            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);

            AUIGrid.setGridData(cnvrListGrid, result.data);


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
        var data = GridCommon.getGridData(cnvrListGrid);
        data.form = $("#newCnvrForm").serializeJSON();

        var idx = AUIGrid.getRowCount(cnvrListGrid);



        if(idx == 0){
            Common.alert("No data to save.");
            return false;
        }

        if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){

            Common.ajax("POST", "/sales/order/savePayConvertList", data, function(result){

                console.log("성공." + JSON.stringify(result));
                console.log("data : " + result.data);

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

    $(function(){
    $('#cnvrType').change(function(){
        $("#newCnvrRem").val('');
        $("#fileSelector").val('');
        $("#hiddenTotal").val('');
        AUIGrid.clearGridData(uploadGrid);
        AUIGrid.clearGridData(cnvrListGrid);


    });
    });




</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Sales</li>
        <li>Order</li>
        <li>Paymode Conversion</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Paymode Conversion Batch</h2>
    </aside><!-- title_line end -->


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
<tr>
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
    </select>
    </p>
    <span><spring:message code="sal.text.to" /></span>
    <p>
    <select class="w100p" id="payCnvrStusTo" name="payCnvrStusTo">
        <option value="REG">REG</option>
    </select>
    </p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td><textarea cols="20" rows="5" id="newCnvrRem" name="newCnvrRem" placeholder="Remark"></textarea></td>
</tr>
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
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_saveNewCnvr();"><spring:message code="sal.btn.save" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_clearBtn"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
    </section><!-- search_table end -->
</section><!-- content end -->

<hr />

</body>
</html>