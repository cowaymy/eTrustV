<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 10/01/2019  ONGHC  1.0.0          CREATE FOR INSTALLATION IMAGE VIEWER
 -->

<style type="text/css">
* {
  box-sizing: border-box
}

body {
  font-family: Verdana, sans-serif;
  margin: 0
}

.mySlides {
  display: none
}

img {
  vertical-align: middle;
}

/* Slideshow container */
.slideshow-container {
  max-width: 1000px;
  position: relative;
  margin: auto;
}

/* Slideshow container */
.slideshow-emptyContainer {
  max-width: 1000px;
  maxHeight : 100%;
  position: relative;
  margin: auto;
}

/* Next & previous buttons */
.prev, .next {
  cursor: pointer;
  position: absolute;
  top: 50%;
  width: auto;
  padding: 16px;
  margin-top: -22px;
  color: white;
  font-weight: bold;
  font-size: 18px;
  transition: 0.6s ease;
  border-radius: 0 3px 3px 0;
  user-select: none;
}

/* Position the "next button" to the right */
.next {
  right: 0;
  border-radius: 3px 0 0 3px;
}

/* On hover, add a black background color with a little bit see-through */
.prev:hover, .next:hover {
  background-color: rgba(0, 0, 0, 0.8);
}

/* Caption text */
.text {
  color: #f2f2f2;
  font-size: 15px;
  padding: 8px 12px;
  position: absolute;
  bottom: 8px;
  width: 100%;
  text-align: center;
}

/* Number text (1/3 etc) */
.numbertext {
  color: #f2f2f2;
  font-size: 12px;
  padding: 8px 12px;
  position: absolute;
  top: 0;
}

/* The dots/bullets/indicators */
.dot {
  cursor: pointer;
  height: 15px;
  width: 15px;
  margin: 0 2px;
  background-color: #bbb;
  border-radius: 50%;
  display: inline-block;
  transition: background-color 0.6s ease;
}

.active, .dot:hover {
  background-color: #717171;
}

/* Fading animation */
.fade {
  -webkit-animation-name: fade;
  -webkit-animation-duration: 1.5s;
  animation-name: fade;
  animation-duration: 1.5s;
}

@
-webkit-keyframes fade {
  from {opacity: .4
}

to {
  opacity: 1
}

}
@
keyframes fade {
  from {opacity: .4
}

to {
  opacity: 1
}

}

/* On smaller screens, decrease text size */
@media only screen and (max-width: 300px) {
  .prev, .next, .text {
    font-size: 11px
  }
}
</style>

<script type="text/javaScript">
  $(document).ready(function(){
    if ("${imgLst}".length <= 2) {
      $("#emtpyContainer").show();
      $("#imgContainer").hide();
    } else {
        $("#emtpyContainer").hide();
        $("#imgContainer").show();
    }


  });

  var slideIndex = 1;
  showSlides(slideIndex);

  function plusSlides(n) {
    showSlides(slideIndex += n);
  }

  function currentSlide(n) {
    showSlides(slideIndex = n);
  }

  function showSlides(n) {
    var i;
    var slides = document.getElementsByClassName("mySlides");
    var dots = document.getElementsByClassName("dot");

    if (slides.length == 0) {
      return;
    }

    if (n > slides.length) {
      slideIndex = 1
    }
    if (n < 1) {
      slideIndex = slides.length
    }
    for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";
    }
    for (i = 0; i < dots.length; i++) {
      dots[i].className = dots[i].className.replace(" active", "");
    }
    slides[slideIndex - 1].style.display = "block";
    dots[slideIndex - 1].className += " active";
  }
</script>

<div id="popup_wrap" class="popup_wrap">

  <section id="content">
    <header class="pop_header">
      <h1>
        <spring:message code='sales.title.InstImgView' />
      </h1>
      <ul class="right_opt">
        <li><p class="btn_blue2">
            <a href="#"><spring:message code='sys.btn.close' /></a>
          </p></li>
      </ul>
    </header>

    <section class="pop_body" id="emtpyContainer" name="emtpyContainer">
     <div class="slideshow-emptyContainer" style="height:100%; weigth:100%">
       <!-- <center style="height:100%; weigth:100%;vertical-align:middle"><p style="font-family:Sans-serif;font-style: oblique;font-size: 16px;font-weight: bold;">No Image Available .. <p></center>  -->
       <center style="height:100%; weigth:100%;"><img src="${pageContext.request.contextPath}/resources/images/common/no-image-icon.png"/></center>
     </div>
    </section>

    <section class="pop_body" id="imgContainer" name="imgContainer" style="display: none;">
      <div class="slideshow-container">

        <c:forEach var="list" items="${imgLst}" varStatus="status">
         <c:choose>
          <c:when test="${list.first}">
           <div class="slideshow-container">
            <img src="/file/fileDownWasMobile.do?fileId=${list.atchFileId}" height="800"  style="width: 100%">
            <div class="text">'${list.atchFileName}'</div>
           </div>
          </c:when>
          <c:otherwise>
           <div class="mySlides fade">
            <img src="/file/fileDownWasMobile.do?fileId=${list.atchFileId}" height="800"  style="width: 100%">
            <div class="text">'${list.atchFileName}'</div>
           </div>
          </c:otherwise>
         </c:choose>
        </c:forEach>

        <!-- Next and previous buttons -->
        <a class="prev" onclick="plusSlides(-1)">&#10094;</a> <a
          class="next" onclick="plusSlides(1)">&#10095;</a>
      </div>
      <br>

      <!-- The dots/circles -->
      <div style="text-align: center">
        <c:forEach var="list2" items="${imgLst}" varStatus="status2">
          <span class="dot" onclick="currentSlide('${status2.count}')"></span>
        </c:forEach>
      </div>
    </section>
    <!-- content end -->
  </section>
  <!-- content end -->
</div>
<!-- popup_wrap end -->
<script>

</script>