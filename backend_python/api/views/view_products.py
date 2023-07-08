from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.models.product import Product
from api.serializers.product_serializer import ProductSerializer

@api_view(['GET'])
def getProducts(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)