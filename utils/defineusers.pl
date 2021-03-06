use REST::Client;
use JSON;
# Data::Dumper makes it easy to see what the JSON returned actually looks like 
# when converted into Perl data structures.
use Data::Dumper;



my $headers = {Accept => 'application/json'};
my $client = REST::Client->new();
$client->setHost('http://localhost:8080/rest');
$client->GET(
    '/collections?limit=1000', 
    $headers
);

my $response = from_json($client->responseContent());


my $counter = 0;
foreach (@$response)
{
  my $uuid = $_->{'uuid'};
  my $command = "/home/dspace-base-funasa/bin/dspace dsrun org.dspace.administer.CollectionSetSubmitersAndReviewers -c $uuid -s Publicadores -1 Revisores";
  my $return = system($command);
   
  
  print $command."\n";
  print $return."\n";
  print "--------------------------------------------------------------------------\n";

}

