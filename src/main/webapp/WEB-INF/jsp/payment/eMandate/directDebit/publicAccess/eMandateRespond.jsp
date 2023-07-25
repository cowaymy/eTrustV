<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/util.js" type="text/javascript"></script>

<script type="text/javaScript">
debugger;
$(document).ready(function(){

   var status= '${data.status}';
   console.log(status);

	if ( status == '00'){
		$("#divSuccess").attr("style", "display:block");
	} else {
		$("#divFail").attr("style", "display:block");
	}
});

function fn_back() {
	// close the pop up
}
</script>

<style>

@font-face {
  font-family: Avenir;
  src: url(/resources/font/Avenir.ttc);
}

#line{padding-left:20px; padding-right:20px;}
.respondPage{font-family:Avenir;background-color:#9dbcd0;color:#FFFFFF; display: block ;text-align: center; padding-bottom:30px;height:-webkit-fill-available}
#info{height: -webkit-calc(90vh - 70px) overflow-y:auto;font-family:Avenir;background-color:#9dbcd0;color:#FFFFFF!important;
        overflow: hidden;}
#logo{display: block;  margin-left: auto;  margin-right: auto;margin-top:20px;font-size:20px; font-weight:bold; font-family:Avenir;color:#FFFFFF;}
.title1{font-size:14px;padding-bottom:15px; font-family:Avenir;color:#FFFFFF;}
.btn {
    color: #90a9b7;
    font-weight: bold;
    font-size: 15px;
    border: 0px solid #90a9b7;
    border-radius: 13px;
    text-align: center;
    min-width: 100px;
    max-width: 200px;
    min-height: 30px;
    line-height: 20px;
    padding: 10px;
    background-color: #FFFFFF;
    margin-left: 10;
    margin-right: 10;
}
table#respTable tbody tr td {font-size:medium; text-align: left; color:#FFFFFF; min-width:100px;}
table#respTable tbody tr td input{font-size:medium ; text-align: center; padding:8px;border:0px solid #90a9b7; border-radius:12px;background-color:#FFFFFF; height:38px; max-width:200px;overflow-y:auto}
table#respTable tbody tr td input:read-only {background: #d2d2d2}
table {width:100%;margin-left:auto; margin-right:auto; display:block;}
/* .container{
    margin: 0 0;
} */
#respTable{
    text-align:center;
    width: 390px;
    padding-bottom: 1%;
    padding-top: 1%;
}
#disclaimer{
    max-width: 450px;
    padding-bottom: 1%;
    padding-top: 1%;
    font-size: 1.5vh;
    font-family:Avenir;
    color:#FFFFFF;

}

</style>

<div id="respondPage" class="respondPage">
    <!-- content start -->
       <input type="hidden" id="clientIp" name="clientIp" value=""/>
       <div style="padding-top: 10px;">
            <img id="logo" width="200px" src="${pageContext.request.contextPath}/resources/images/common/Coway Logo_white-01.png"/>
        </div>
        <div id="divFail" style="padding-top: 1%; padding-left: 5%; padding-right: 5%; display:none">

            <div class="logo">
                <h2>Direct Debit Registration</h2>
                <br/>
                <h2 style="color:red;">Error! Kindly Contact Administrator.</h2>
            </div>
            <div class="container">
                <table id="respTable" style="border: none;">
                    <tbody>

                        <tr>
                            <td colspan="2" style="font-size:large;"></td>
                        </tr>
                        <br/>
                        <tr>
                            <td id="label">Payment ID:</td>
                            <td>${data.payId}</td>
                        </tr>
                        <tr>
                            <td id="label">Status:</td>
                            <td>${data.status}</td>
                        </tr>


                    </tbody>
                </table>
            </div>
            <br/> <br/>

            <div>
                <button type="button" class="btn" onclick="javascript:fn_back();">BACK</button>
            </div>
        </div>

        <div id="divSuccess" style="padding-top: 1%; padding-left: 5%; padding-right: 5%; display:none">

            <div class="logo">
                <h2>Direct Debit Registration</h2>
                <br/>
                <h2>THANK YOU FOR SIGNING UP.</h2>
            </div>
            <div class="container">
                <table id="respTable" style="border: none;">
                    <tbody>

                        <tr>
                            <td colspan="2" style="font-size:large;"></td>
                        </tr>
                        <br/>
                        <tr>
                            <td id="label">Payment ID:</td>
                            <td>${data.payId}</td>
                        </tr>
                        <tr>
                            <td id="label">Status:</td>
                            <td>${data.status}</td>
                        </tr>


                    </tbody>
                </table>
            </div>
            <br/> <br/>

            <div>
                <button type="button" class="btn" onclick="javascript:fn_back();">BACK</button>
            </div>
        </div>
</div>