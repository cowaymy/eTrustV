<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(function()
{
  
});

function fnSaveAccount() 
{
   var countryVal = $("#mcountry option:selected").val();

   if (countryVal == 1)
   {
     if ( parseInt($("#mstate option").index($("#mstate option:selected")))  == 0)
       {           
         Common.alert(' Please select the state.');
         return false;
       }
       
       if (parseInt($("#marea option").index($("#marea option:selected")))  == 0)
       {
           Common.alert(' Please select the area.');
           return false;
       }

       if (parseInt($("#mpostcd option").index($("#mpostcd option:selected"))) == 0)
       {
           Common.alert(' Please select the postcode.');
           return false;
       }
   }


   if ($("#popUpAccCode").val().length == 0)
   {
     Common.alert(' Please key in the account code.');
     return false;
   }
   
   if ($("#popUpAccDesc").val().length == 0)
   {
     Common.alert(' Please key in the account description.');
     return false;
   }

   

    Common.ajax("POST", "/account/insertAccount.do"
            , $("#PopUpForm").serializeJSON({checkboxUncheckedValue: "false"})  // post 시 serializeJSON
            , function(result) 
             {
                if(result.code == 99){
                  Common.alert(result.message);
                }else{
                  alert(result.data + " Count Save Success!");
                  console.log("성공." + JSON.stringify(result));
                  console.log("data : " + result.data);
                  fnGetAccountCdListAjax();                 
                }
             } 
           , function(jqXHR, textStatus, errorThrown) 
            {
              try 
              {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
              } 
              catch (e) 
              {
                console.log("error: " + e);
              }
              Common.alert("Fail : " + jqXHR.responseJSON.message);
            });

}

 function fnClose(){
   $("#_popupDiv").remove(); // hide();
}
</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Add Program</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="javascript:fnClose();" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<body>
  <form id="PopUpForm" name="PopUpForm" method="" action="">
		<section class="pop_body"><!-- pop_body start -->
		
		<aside class="title_line mt20"><!-- title_line start -->
		<h2 class="pt0">Program Information</h2>
		</aside><!-- title_line end -->
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:120px" />
			<col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">ID</th>
			<td>
			<input type="text" title="" placeholder="" class="" />
			</td>
		</tr>
		<tr>
			<th scope="row">Name</th>
			<td>
			<input type="text" title="" placeholder="" class="" />
			</td>
		</tr>
		<tr>
			<th scope="row">Path</th>
			<td>
			<input type="text" title="" placeholder="" class="" />
			</td>
		</tr>
		<tr>
			<th scope="row">Desc</th>
			<td>
			<input type="text" title="" placeholder="" class="" />
			</td>
		</tr>
		</tbody>
		</table><!-- table end -->
		
		<aside class="title_line mt20"><!-- title_line start -->
		<h2 class="pt0">Transaction</h2>
		</aside><!-- title_line end -->
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
			<col style="width:150px" />
			<col style="width:120px" />
			<col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">Auth</th>
			<td colspan="2">
			<label><input type="checkbox" /><span>View</span></label>
			<label><input type="checkbox" /><span>Change</span></label>
			<label><input type="checkbox" /><span>Print</span></label>
			</td>
		</tr>
		<tr>
			<th scope="row" rowspan="2" class="border_right">User Defined #1</th>
			<th scope="row">APPLY_YN</th>
			<td>
			<label><input type="checkbox" /></label>
			</td>
		</tr>
		<tr>
			<th scope="row">DESC</th>
			<td>
			 <input type="text" id="txt1" name="txt1" title="" placeholder="description #1" class="w100p" />
			</td>
		</tr>
		<tr>
			<th scope="row" rowspan="2" class="border_right">User Defined #2</th>
			<th scope="row">APPLY_YN</th>
			<td>
			<label><input type="checkbox" /></label>
			</td>
		</tr>
		<tr>
			<th scope="row">DESC</th>
			<td>
			<span>Confirm</span>
			</td>
		</tr>
		<tr>
			<th scope="row" rowspan="2" class="border_right">User Defined #3</th>
			<th scope="row">APPLY_YN</th>
			<td>
			<label><input type="checkbox" /></label>
			</td>
		</tr>
		<tr>
			<th scope="row">DESC</th>
			<td>
			</td>
		</tr>
		<tr>
			<th scope="row" rowspan="2" class="border_right">User Defined #4</th>
			<th scope="row">APPLY_YN</th>
			<td>
			<label><input type="checkbox" /></label>
			</td>
		</tr>
		<tr>
			<th scope="row">DESC</th>
			<td>
			</td>
		</tr>
		<tr>
			<th scope="row" rowspan="2" class="border_right">User Defined #5</th>
			<th scope="row">APPLY_YN</th>
			<td>
			<label><input type="checkbox" /></label>
			</td>
		</tr>
		<tr>
			<th scope="row">DESC</th>
			<td>
			</td>
		</tr>
		</tbody>
		</table><!-- table end -->
		
		<ul class="center_btns">
			<li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
		</ul>
		</section><!-- pop_body end -->
	</form>
	
 </body>
 
</div><!-- popup_wrap end -->
</html>